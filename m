Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3DVGY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 02:24:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21741 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab3DVGYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 02:24:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,524,1363104000"; 
   d="scan'208";a="7110372"
Subject: Re: [PATCH 1/2] smp: use '|=' for csd_lock
From: li guang <lig.fnst@cn.fujitsu.com>
To: sedat.dilek@gmail.com
Cc: tglx@linutronix.de, peterz@infradead.org, akpm@linux-foundation.org,
        shli@fusionio.com, srivatsa.bhat@linux.vnet.ibm.com,
        suresh.b.siddha@intel.com, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <CA+icZUVd3zp-pJDspBUsipH4725uUvaufXrK0QBzcrozF2m+aA@mail.gmail.com>
References: <1366609643-17628-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <CA+icZUVd3zp-pJDspBUsipH4725uUvaufXrK0QBzcrozF2m+aA@mail.gmail.com>
Date: Mon, 22 Apr 2013 14:22:29 +0800
Message-ID: <1366611749.27110.6.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/22 14:22:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/22 14:22:51,
	Serialize complete at 2013/04/22 14:22:51
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-04-22一的 08:18 +0200，Sedat Dilek写道：
> On Mon, Apr 22, 2013 at 7:47 AM, liguang <lig.fnst@cn.fujitsu.com> wrote:
> > originally, 'data->flags = CSD_FLAG_LOCK',
> > and we use 'data->flags &= ~CSD_FLAG_LOCK'
> > for csd_unlock, they are not symmetrix operations
> > so use '|=' instead of '='.
> > though, now data->flags only hold CSD_FLAG_LOCK,
> > it's not so meaningful to use '|=' to set 1 bit,
> > and '&= ~' to clear 1 bit.
> >
> 
> Hi,
> 
> what's the reason I got CCed on this two patches? The ipc-sem-next
> issue I reported?

sorry,
just use the result of scripts/get_maintainer.pl

> 
> Against what tree are those patches?
> They are not compatible with Linux-Next (next-20130419).

main

> 
> Thanks.
> 
> Regards,
> - Sedat -
> 
> [1] http://marc.info/?t=136631457900005&r=1&w=2
> 
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> > ---
> >  kernel/smp.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/smp.c b/kernel/smp.c
> > index 1818dc0..2d5deb4 100644
> > --- a/kernel/smp.c
> > +++ b/kernel/smp.c
> > @@ -109,7 +109,7 @@ static void csd_lock_wait(struct call_single_data *data)
> >  static void csd_lock(struct call_single_data *data)
> >  {
> >         csd_lock_wait(data);
> > -       data->flags = CSD_FLAG_LOCK;
> > +       data->flags |= CSD_FLAG_LOCK;
> >
> >         /*
> >          * prevent CPU from reordering the above assignment
> > --
> > 1.7.2.5
> >



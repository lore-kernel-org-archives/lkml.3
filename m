Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3KYMNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:13:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab3KYMNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:13:07 -0500
Date: Mon, 25 Nov 2013 13:14:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: zhang.yi20@zte.com.cn
Cc: Tejun Heo <tj@kernel.org>, htejun@gmail.com,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: =?utf-8?B?562U5aSNOiBSZTogW1BBVENIIDEv?=
	=?utf-8?Q?1=5D_workqueue?=
	=?utf-8?Q?=3A?= swap set_cpus_allowed_ptr() and PF_NO_SETAFFINITY
Message-ID: <20131125121416.GB23829@redhat.com>
References: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn> <20131114052326.GA29031@mtj.dyndns.org> <20131114114039.GA29277@redhat.com> <20131114115551.GA30824@redhat.com> <20131114115618.GB30824@redhat.com> <CAOS58YO_pZzBB+T6FEzNqfZv4_UUQ_QF1n1zxy4u+H_KhW-vJQ@mail.gmail.com> <OF36E72FA9.51146BE3-ON48257C2E.0008BC6D-48257C2E.0008FF9C@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF36E72FA9.51146BE3-ON48257C2E.0008BC6D-48257C2E.0008FF9C@zte.com.cn>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, zhang.yi20@zte.com.cn wrote:
>
> htejun@gmail.com wrote on 2013/11/23 07:13:43:
>
> >
> > Re: [PATCH 1/1] workqueue: swap set_cpus_allowed_ptr() and PF_NO_SETAFFINITY
> >
> > On Thu, Nov 14, 2013 at 6:56 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > > Move the setting of PF_NO_SETAFFINITY up before set_cpus_allowed()
> > > in create_worker(). Otherwise userland can change ->cpus_allowed
> > > in between.
> > >
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> >
> > Applied to wq/for-3.13-fixes.
> >
> > Thanks!
> >
> > --
> > tejun
>
> How about the first patch?

Let me quote myself:

	Looks like Zhang is right... But I'd suggest to change flush_old_exec()
	instead (see "current->flags &= ...").

Do you agree? If yes, could you make v2? flush_old_exec() already clears
the unwanted PF_ bits, I do not think we should add another place.

Oleg.


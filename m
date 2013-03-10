Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3CJI7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:59:13 -0400
Received: from mx0.parallels.com ([199.115.104.20]:43847 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3CJI7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:59:11 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Akinobu Mita <akinobu.mita@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH -mmotm] scsi: fix the wrong position of the comment
Thread-Topic: [PATCH -mmotm] scsi: fix the wrong position of the comment
Thread-Index: AQHOHWaugnbpva3RokGvOc0XzwiVrJifC22AgAAJpwCAAACAgA==
Date: Sun, 10 Mar 2013 08:59:06 +0000
Message-ID: <1362905945.3003.4.camel@dabdike.int.hansenpartnership.com>
References: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
	 <1362903765.3003.2.camel@dabdike.int.hansenpartnership.com>
	 <20130310005718.2d6579ea.akpm@linux-foundation.org>
In-Reply-To: <20130310005718.2d6579ea.akpm@linux-foundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [46.65.52.191]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <DAF5CC695A92964B94D375C3751915FB@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-10 at 00:57 -0800, Andrew Morton wrote:
> On Sun, 10 Mar 2013 08:22:47 +0000 James Bottomley <jbottomley@parallels.com> wrote:
> 
> > [missing SCSI cc added]
> > On Sun, 2013-03-10 at 17:09 +0900, Akinobu Mita wrote:
> > > This fixes the wrong position of the comment introduced by
> > > scsi-rename-random32-to-prandom_u32.patch in the -mm tree.
> > > 
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> > > Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > > ---
> > >  drivers/scsi/qla2xxx/qla_attr.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> > > index 04bf7b8..e44d47e 100644
> > > --- a/drivers/scsi/qla2xxx/qla_attr.c
> > > +++ b/drivers/scsi/qla2xxx/qla_attr.c
> > > @@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
> > >  	}
> > >  
> > >  	/* No pending activities shall be there on the vha now */
> > > -	if (ql2xextended_error_logging & ql_dbg_user)
> > > -		msleep(prandom_u32() % 10);
> > > +	if (ql2xextended_error_logging & ql_dbg_user) {
> > >  		/*
> > >  		 * Just to see if something falls on the net we have placed
> > >  		 * below
> > >  		 */
> > > -
> > > +		msleep(prandom_u32() % 10);
> > > +	}
> > 
> > I don't git a toss if it's random or prandom: Andrew: get rid of it; we
> > do not sleep in kernel for random intervals whatever the provocation ...
> > if this is supposed to be a warning or error condition then print
> > something.
> 
> That msleep was added by
> 
> commit feafb7b1714cf599a6d0fed45801ab3f66046cbd
> Author:     Arun Easi <arun.easi@qlogic.com>
> AuthorDate: Fri Sep 3 14:57:00 2010 -0700
> Commit:     James Bottomley <James.Bottomley@suse.de>
> CommitDate: Sun Sep 5 15:13:12 2010 -0300
> 
>     [SCSI] qla2xxx: Fix vport delete issues

Sorry, I didn't notice multiple Andrews on the cc list.  I meant Andrew
Vasquez (or other member of the qla team) remove this, please (and
preferably do something correct).

Thanks,

James


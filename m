Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3CJI44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 04:56:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3CJI4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 04:56:54 -0400
Date: Sun, 10 Mar 2013 00:57:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <jbottomley@parallels.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH -mmotm] scsi: fix the wrong position of the comment
Message-Id: <20130310005718.2d6579ea.akpm@linux-foundation.org>
In-Reply-To: <1362903765.3003.2.camel@dabdike.int.hansenpartnership.com>
References: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
	<1362903765.3003.2.camel@dabdike.int.hansenpartnership.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Mar 2013 08:22:47 +0000 James Bottomley <jbottomley@parallels.com> wrote:

> [missing SCSI cc added]
> On Sun, 2013-03-10 at 17:09 +0900, Akinobu Mita wrote:
> > This fixes the wrong position of the comment introduced by
> > scsi-rename-random32-to-prandom_u32.patch in the -mm tree.
> > 
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> > Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_attr.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> > index 04bf7b8..e44d47e 100644
> > --- a/drivers/scsi/qla2xxx/qla_attr.c
> > +++ b/drivers/scsi/qla2xxx/qla_attr.c
> > @@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
> >  	}
> >  
> >  	/* No pending activities shall be there on the vha now */
> > -	if (ql2xextended_error_logging & ql_dbg_user)
> > -		msleep(prandom_u32() % 10);
> > +	if (ql2xextended_error_logging & ql_dbg_user) {
> >  		/*
> >  		 * Just to see if something falls on the net we have placed
> >  		 * below
> >  		 */
> > -
> > +		msleep(prandom_u32() % 10);
> > +	}
> 
> I don't git a toss if it's random or prandom: Andrew: get rid of it; we
> do not sleep in kernel for random intervals whatever the provocation ...
> if this is supposed to be a warning or error condition then print
> something.

That msleep was added by

commit feafb7b1714cf599a6d0fed45801ab3f66046cbd
Author:     Arun Easi <arun.easi@qlogic.com>
AuthorDate: Fri Sep 3 14:57:00 2010 -0700
Commit:     James Bottomley <James.Bottomley@suse.de>
CommitDate: Sun Sep 5 15:13:12 2010 -0300

    [SCSI] qla2xxx: Fix vport delete issues




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3KVI3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:29:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3KVI3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:29:19 -0500
Date: Fri, 22 Nov 2013 11:29:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Andreas Platschek <andi.platschek@gmail.com>, gregkh@linuxfoundation.org,
        jslaby@suse.cz, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tty: replace mutex_lock() with tty_write_lock()
Message-ID: <20131122082907.GB5302@mwanda>
References: <1385061132-7254-1-git-send-email-andi.platschek@gmail.com>
 <528F112B.4090404@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F112B.4090404@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:09:15AM +0100, walter harms wrote:
> 
> 
> Am 21.11.2013 20:12, schrieb Andreas Platschek:
> > Use tty_write_lock()/tty_write_unlock() consistently.
> > 
> > This takes care of the following sparse warning:
> > drivers/tty/tty_io.c:1169:17: warning: context imbalance in 'tty_write_message' - unexpected unlock
> > 
> > Signed-off-by: Andreas Platschek <andi.platschek@gmail.com>
> > ---
> >  drivers/tty/tty_io.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> > index 3a1a01a..13dca92 100644
> > --- a/drivers/tty/tty_io.c
> > +++ b/drivers/tty/tty_io.c
> > @@ -1165,7 +1165,7 @@ out:
> >  void tty_write_message(struct tty_struct *tty, char *msg)
> >  {
> >  	if (tty) {
> > -		mutex_lock(&tty->atomic_write_lock);
> > +		tty_write_lock(tty,0);
> >  		tty_lock(tty);
> >  		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
> >  			tty_unlock(tty);
> 
> i am not an expert on this but you may need to replace that tty_unlock() with tty_write_unlock().

No.  The original code is correct.

regards,
dan carpenter


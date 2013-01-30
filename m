Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3A3IJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:09:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:44460 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3A3IJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:09:00 -0500
Date: Tue, 29 Jan 2013 23:36:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Karthik Manamcheri <Karthik.Manamcheri@ni.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew McGregor <andrew.mcgregor@alliedtelesis.co.nz>
Subject: Re: [PATCH] n_tty: Unthrottle tty when flushing read buffer
Message-ID: <20130130043654.GA30002@kroah.com>
References: <1358980578-8811-1-git-send-email-Karthik.Manamcheri@ni.com>
 <5106F8F6.80101@ilyx.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5106F8F6.80101@ilyx.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 02:17:26AM +0400, Ilya Zykov wrote:
> On 24.01.2013 2:36, Karthik Manamcheri wrote:
> > When the tty input buffer is full and thereby throttled,
> > flushing/resetting the read buffer should unthrottle to allow more
> > data to be received.
> > 
> > Signed-off-by: Karthik Manamcheri <Karthik.Manamcheri@ni.com>
> > ---
> >  drivers/tty/n_tty.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> > index 19083efa2314660b25e0fb5bc793af6fb7e9af57..d5cea3bb01eaeec61b577de6c58a8000412c0c37 100644
> > --- a/drivers/tty/n_tty.c
> > +++ b/drivers/tty/n_tty.c
> > @@ -229,6 +229,8 @@ static void reset_buffer_flags(struct tty_struct *tty)
> >  	ldata->canon_head = ldata->canon_data = ldata->erasing = 0;
> >  	bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
> >  	n_tty_set_room(tty);
> > +
> > +	check_unthrottle(tty);
> >  }
> >  
> >  /**
> > 
> 
> It's revert - tty: fix "IRQ45: nobody cared".
> commit 7b292b4bf9a9d6098440d85616d6ca4c608b8304
> 
> Please, read these for this subject:
> https://lkml.org/lkml/2012/11/27/440
> https://lkml.org/lkml/2012/11/21/568
> 
> https://lkml.org/lkml/2012/11/22/686
> 
> It's already fixed in the:
> commit a1bf9584429d61b7096f93ae09325e1ba538e9e8
> tty: Add driver unthrottle in ioctl(...,TCFLSH,..).

Sorry about that, I'll go revert this now, my fault.

greg k-h

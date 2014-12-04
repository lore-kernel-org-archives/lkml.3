Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385AbaLDX3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:29:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbaLDX3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:29:52 -0500
Date: Thu, 4 Dec 2014 15:29:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Misc: pass miscdevice through file's private_data
Message-ID: <20141204232951.GA13690@kroah.com>
References: <20141204211342.GA22293@kroah.com>
 <1417734063-28489-1-git-send-email-tomvanbraeckel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417734063-28489-1-git-send-email-tomvanbraeckel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 12:01:03AM +0100, Tom Van Braeckel wrote:
> > >  
> > > +	/*
> > > +	 * Place the miscdevice in the file's
> > > +	 * private_data so it can be used by the
> > > +	 * file operations, including f_op->open below
> > > +	 */
> > > +	file->private_data = c;
> > > +
> > >  	err = 0;
> > >  	replace_fops(file, new_fops);
> > >  	if (file->f_op->open) {
> > > -		file->private_data = c;
> > >  		err = file->f_op->open(inode,file);
> > >  	}
> >
> > These braces aren't needed anymore, right?
> >
> > Also, what is this now going to break?  :)
> > 
> > thanks,
> > 
> > greg k-h
> 
> Thanks for the fast feedback!
> 
> Good point, so I made a list of all drivers that use private_data (find drivers/ -iname "*.c" -exec grep -l private_data {} \;  | sort -u) and manually verified that all of them either register an open() operation, do not use the misc subsystem, or matched because of vm_private_data.
> 
> >From this investigation, I conclude that it does not break anything.
> 
> I also removed the unnecessary curly braces. Please find the new patch below.
> 
> 
> misc: pass miscdevice through file's private_data
> 
> Place the miscdevice in the file's private_data to be used by the file operations.
> 
> Previously, this was done only when an open() operation had been registered.
> But it is also useful in the other file operations, so we pass it on unconditionally.
> 
> All drivers that use private_data and misc_register() were checked to ensure they register an open() operation,
> in order to verify that this improvement does not break any existing driver that uses the misc subsystem.
> 
> Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>
> ---
>  drivers/char/misc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

Please resend this in a format I can apply it in (standalone, lines
properly wrapped, etc.)

thanks,

greg k-h

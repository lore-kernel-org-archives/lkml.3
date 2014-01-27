Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaA0X0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:26:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaA0X0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:26:31 -0500
Date: Mon, 27 Jan 2014 15:27:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, xypron.glpk@gmx.de, linux-usb@vger.kernel.org,
        ly80toro@cip.cs.fau.de, linux-kernel@vger.kernel.org,
        ke42caxa@cip.cs.fau.de
Subject: Re: [PATCH 1/1] usbip/userspace/libsrc/names.c: memory leak
Message-ID: <20140127232736.GA652@kroah.com>
References: <1390861789-8981-1-git-send-email-xypron.glpk@gmx.de>
 <20140127225004.GA17970@kroah.com>
 <20140127230212.GA5364@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127230212.GA5364@mwanda>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 02:02:12AM +0300, Dan Carpenter wrote:
> On Mon, Jan 27, 2014 at 02:50:04PM -0800, Greg KH wrote:
> > On Mon, Jan 27, 2014 at 11:29:48PM +0100, xypron.glpk@gmx.de wrote:
> > > From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> > > 
> > > p is freed if NULL.
> > 
> > Not a real problem, right?
> > 
> > > p is leaked if second calloc fails.
> > 
> > You just created a new bug in your "fix" :(
> > 
> > Please run your patches through scripts/checkpatch.pl, odds are, it
> > would have caught this error.
> > 
> 
> Checkpatch doesn't catch the problems here.  I thought it would have
> caught the style issue but apparently it only looks for extra curly
> braces when you run it in --file mode.

Ah, that's good to know.

> Fengguang would hopefully have caught the missing curly braces bug with
> Coccinelle.

Is Coccinelle run on the userspace .c code in the kernel?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbbAZWq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 17:46:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbbAZWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 17:46:55 -0500
Date: Mon, 26 Jan 2015 14:46:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>, isdn@linux-pingi.de,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: make allyesconfig i386 build failure with next-20150122 (caused
 by fb_agm1264k-fl driver)
Message-ID: <20150126224654.GA17166@kroah.com>
References: <CA+r1ZhhXF+hicy7JKo3jAbgSbO4KOLm6BwPosTKNb+E_Cb4yPQ@mail.gmail.com>
 <20150126215959.GA9853@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126215959.GA9853@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:59:59PM -0800, Guenter Roeck wrote:
> On Thu, Jan 22, 2015 at 12:10:33PM -0700, Jim Davis wrote:
> > make ARCH=i386 allyesconfig fails with
> > 
> > drivers/staging/built-in.o: In function `reset':
> > (.text+0x2ae89d): multiple definition of `reset'
> > drivers/isdn/built-in.o:(.text+0x185dc2): first defined here
> > make[1]: *** [drivers/built-in.o] Error 1
> 
> Culprit:
> 
> commit b2ebd4be6fa1d2329b63531b044f9e25474981cb
> Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Date:   Wed Dec 31 10:11:10 2014 +0100
> 
>     staging: fbtft: add fb_agm1264k-fl driver
> 
> A global function named 'reset' isn't really a good idea.
> 
> Not that the global function with the same name in the isdn code
> is better ;-).

Agreed, the fbtft code is now fixed.  Patches to fix the isdn code would
be gladly accepted as well :)

thanks,

greg k-h

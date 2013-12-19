Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab3LSDAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 22:00:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3LSDAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 22:00:19 -0500
Date: Wed, 18 Dec 2013 19:00:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/118] 3.12.6-stable review
Message-ID: <20131219030022.GA15867@kroah.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218234857.GA23500@roeck-us.net>
 <20131219025658.GA9372@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219025658.GA9372@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 06:56:58PM -0800, Greg Kroah-Hartman wrote:
> On Wed, Dec 18, 2013 at 03:48:57PM -0800, Guenter Roeck wrote:
> > On Wed, Dec 18, 2013 at 01:10:37PM -0800, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 3.12.6 release.
> > > There are 118 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri Dec 20 21:12:03 UTC 2013.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Hi greg,
> > 
> > I see a couple of failed builds.
> > 
> > m68k:allmodconfig ... failed
> > mips:allmodconfig ... failed
> > sparc64:allmodconfig ... failed
> > x86_64:allyesconfig ... failed
> > x86_64:allmodconfig ... failed
> > 
> > Build is still going on, so there may be more.
> > 
> > Error log:
> > 
> > drivers/staging/comedi/drivers/ssv_dnp.c: In function 'dnp_dio_insn_bits':
> > drivers/staging/comedi/drivers/ssv_dnp.c:63:2: error: implicit declaration of function 'comedi_dio_update_state' [-Werror=implicit-function-declaration]
> > cc1: some warnings being treated as errors
> > make[4]: *** [drivers/staging/comedi/drivers/ssv_dnp.o] Error 1
> > 
> > Function comedi_dio_update_state() is not defined anywhere in 3.12,
> > so patches
> > 	 staging: comedi: ssv_dnp: use comedi_dio_update_state()
> > 	 staging: comedi: drivers: use comedi_dio_update_state() for simple cases
> > 
> > won't apply without additional changes.
> 
> Odd, let me see what happened, as I thought this was building properly
> on my test boxes...

Ah, I didn't have COMPILE_TEST enabled, now I see the problem, my fault,
I'll go fix this up now...

greg k-h

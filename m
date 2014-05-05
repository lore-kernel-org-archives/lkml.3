Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaEEUkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:40:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaEEUki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:40:38 -0400
Date: Mon, 5 May 2014 13:43:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/86] 3.10.39-stable review
Message-ID: <20140505204343.GA18222@kroah.com>
References: <20140504154140.444932005@linuxfoundation.org>
 <536683D0.5000708@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536683D0.5000708@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 11:15:44AM -0700, Guenter Roeck wrote:
> On 05/04/2014 08:40 AM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.39 release.
> >There are 86 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Tue May  6 15:41:13 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> I am still seeing build failures, even with x86_64 (both allmodconfig and
> allyesconfig fail).
> 	total: 127 pass: 113 skipped: 4 fail: 10
> 
> drivers/usb/musb/musb_core.c: In function 'musb_stage0_irq':
> drivers/usb/musb/musb_core.c:673:26: error: 'struct musb' has no member named 'hcd'
> 
> Problem is due to 'usb: musb: avoid NULL pointer dereference'.
> A brief glance into the code suggests that the patch will require an explicit
> back-port to 3.10.

Thanks, I've now dropped that one.

> Greg, I suspect you might not have USB_MUSB_HDRC enabled in your builds.

I don't :(

I'm running with a distro kernel config in the builds to let me build
the kernel, which doesn't pick up a lot of the embedded options, like
musb.

thanks,

greg k-h

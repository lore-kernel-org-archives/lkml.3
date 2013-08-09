Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030773Ab3HITLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:11:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030485Ab3HITLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:11:31 -0400
Date: Fri, 9 Aug 2013 12:11:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/102] 3.10.6-stable review
Message-ID: <20130809191130.GD10130@kroah.com>
References: <20130809015010.208118575@linuxfoundation.org>
 <520492F3.1050806@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520492F3.1050806@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 11:57:55PM -0700, Guenter Roeck wrote:
> On 08/08/2013 06:56 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.6 release.
> >There are 102 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sun Aug 11 01:46:31 UTC 2013.
> >Anything received after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
> >and the diffstat can be found below.
> >
> 
> Cross build results:
> 	Total builds: 69 Total build errors: 2
> 
> Details:
> 	http://server.roeck-us.net:8010/builders/stable-queue-3.10/builds/47/steps/shell/logs/stdio/text
> 
> Same results as before, except that I dropped a couple of builds and added some others.

Thanks for testing.

> The failing builds are arm:allmodconfig and mips:allmodconfig.
> For both, the errors don't exist in mainline and should be trivial to fix in case anyone is interested.
> 
> arm:
> 	FATAL: modpost: GPL-incompatible module bcm2835-rng.ko uses GPL-only symbol 'platform_driver_unregister'
> 
> [This one has been fixed upstream with commit 22e8099f4f6621b8d165e238cdef2a1cf655e159. Might be worthwhile
>  adding it to -stable]

Yes, I've now queued it up, thanks.

> mips:
> 	drivers/net/ethernet/3com/3c59x.c:1031:2: error: implicit declaration of function 'pci_iomap'
> 	drivers/net/ethernet/3com/3c59x.c:1044:3: error: implicit declaration of function 'pci_iounmap'
> 
> [no idea why this works upstream]

Odd.  If someone cares about MIPS I hope I'll get a fix for it :)

thanks,

greg k-h

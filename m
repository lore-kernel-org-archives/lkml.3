Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaBRQeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:34:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54058 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaBRQeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:34:10 -0500
Message-ID: <53038B7F.1070506@infradead.org>
Date: Tue, 18 Feb 2014 08:34:07 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        David Barksdale <dbarksdale@uplogix.com>
Subject: Re: linux-next: Tree for Feb 18 (hid/hid-cp2112.c)
References: <20140218160612.34d64514ade66fcb21a6cc0f@canb.auug.org.au>
In-Reply-To: <20140218160612.34d64514ade66fcb21a6cc0f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/14 21:06, Stephen Rothwell wrote:
> Hi all,
> 
> If you see failures in building this tree due to missing declarations of
> k..alloc/free, then it may be caused by commit 2bd59d48ebfb ("cgroup:
> convert to kernfs").  Please send Tejun Heo <tj@kernel.org> a patch
> adding an inclusion of linux/slab.h to the appropriate file(s).
> 
> This tree fails (more than usual) the powerpc allyesconfig build.
> 
> Changes since 20140217:
> 

on x86_64:
when GPIOLIB is not enabled.

Add
	depends on GPIOLIB
to drivers/hid/Kconfig?


  CC [M]  drivers/hid/hid-cp2112.o
drivers/hid/hid-cp2112.c:162:19: error: field 'gc' has incomplete type
drivers/hid/hid-cp2112.c: In function 'cp2112_gpio_direction_input':
drivers/hid/hid-cp2112.c:171:30: warning: initialization from incompatible pointer type [enabled by default]
drivers/hid/hid-cp2112.c:171:30: warning: (near initialization for 'dev') [enabled by default]
drivers/hid/hid-cp2112.c: In function 'cp2112_gpio_set':
drivers/hid/hid-cp2112.c:200:30: warning: initialization from incompatible pointer type [enabled by default]
drivers/hid/hid-cp2112.c:200:30: warning: (near initialization for 'dev') [enabled by default]
drivers/hid/hid-cp2112.c: In function 'cp2112_gpio_get':
drivers/hid/hid-cp2112.c:218:30: warning: initialization from incompatible pointer type [enabled by default]
drivers/hid/hid-cp2112.c:218:30: warning: (near initialization for 'dev') [enabled by default]
drivers/hid/hid-cp2112.c: In function 'cp2112_gpio_direction_output':
drivers/hid/hid-cp2112.c:237:30: warning: initialization from incompatible pointer type [enabled by default]
drivers/hid/hid-cp2112.c:237:30: warning: (near initialization for 'dev') [enabled by default]
drivers/hid/hid-cp2112.c: In function 'cp2112_probe':
drivers/hid/hid-cp2112.c:944:2: error: implicit declaration of function 'gpiochip_add' [-Werror=implicit-function-declaration]
/local/lnx/next/linux-next-20140218/drivers/hid/hid-cp2112.c:962:2: error: implicit declaration of function 'gpiochip_remove' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/hid/hid-cp2112.o] Error 1



-- 
~Randy

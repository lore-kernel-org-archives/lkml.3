Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab3ILU4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:56:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40038 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab3ILU4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:56:20 -0400
Message-ID: <52322A4B.9050205@zytor.com>
Date: Thu, 12 Sep 2013 13:55:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Mark Salter <msalter@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, rth@twiddle.net, vgupta@synopsys.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, geert@linux-m68k.org,
        monstr@monstr.eu, ralf@linux-mips.org, jejb@parisc-linux.org,
        benh@kernel.crashing.org, lethal@linux-sh.org, davem@davemloft.net,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn, tglx@linutronix.de,
        mingo@redhat.com
Subject: Re: [PATCH] Kconfig cleanup (PARPORT_PC dependencies)
References: <1379012038-31764-1-git-send-email-msalter@redhat.com> <52321F0B.4070609@zytor.com> <20130912205349.GC3262@gmail.com>
In-Reply-To: <20130912205349.GC3262@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 01:53 PM, Ingo Molnar wrote:
>>
>> I'm somewhat astonished that this driver is that problematic.  It is 
>> really just a very basic PIO interface, at least in the absence of 
>> EPP/ECP.
>>
>> It is, of course, also largely a dead interface at this point so it 
>> probably doesn't matter.
> 
> So, my collection of 'randconfig kernel crashers' has this exclusion and 
> comment:
> 
>  --- linux.orig/drivers/block/Kconfig
>  +++ linux/drivers/block/Kconfig
>  @@ -77,6 +77,11 @@ config GDROM
>   config PARIDE
>          tristate "Parallel port IDE device support"
>          depends on PARPORT_PC
>  +
>  +       # the probe can hang during bootup on non-PARIDE boxes
>  +       depends on BROKEN_BOOT_ALLOWED
>  +       select BROKEN_BOOT if PARIDE = y
>  +
> 
> So at least some uses of PARPORT_PC are unsafe. (might easily be a bug in 
> PARIDE)
> 

That I would believe.

	-hpa



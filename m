Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3GSXVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:21:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49160 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab3GSXVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:21:32 -0400
Message-ID: <51E9C9E5.2060602@zytor.com>
Date: Fri, 19 Jul 2013 16:21:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak <ak@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp> <2493652.fjZLqTL8IF@vostro.rjw.lan> <1374257329.22432.382.camel@schen9-DESK> <4295105.1txhDL4OOg@vostro.rjw.lan> <20130719231630.GC1701@kroah.com>
In-Reply-To: <20130719231630.GC1701@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 04:16 PM, Greg Kroah-Hartman wrote:
> 
> udev isn't doing any module loading, 'modprobe' is just being called for
> any new module alias that shows up in the system, and all of the drivers
> that match it then get loaded.
> 
> How is it a problem if a module is attempted to be loaded that is
> already loaded?  How is it a problem if a different module is loaded for
> a device already bound to a driver?  Both of those should be total
> "no-ops" for the kernel.
> 
> But, I don't know anything about the cpu code, how is loading a module
> causing problems?  That sounds like it needs to be fixes, as any root
> user can load modules whenever they want, you can't protect the kernel
> from doing that.
> 

The issue here seems to be the dynamic binding nature of the crypto
subsystem.  When something needs crypto, it will request the appropriate
crypto module (e.g. crct10dif), which may race with detecting a specific
hardware accelerator based on CPUID or device information (e.g.
crct10dif_pclmul).

RAID has effectively the same issue, and we just "solved" it by
compiling in all the accelerators into the top-level module.

	-hpa


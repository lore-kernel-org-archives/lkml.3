Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaH2Bog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:44:36 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43310 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaH2Boe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:44:34 -0400
Message-ID: <53FFDABE.3000507@ahsoftware.de>
Date: Fri, 29 Aug 2014 03:43:26 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <20140826084208.AE5F0C40989@trevor.secretlab.ca> <20140826084922.GG17263@ulmo> <53FC566C.30904@ahsoftware.de> <20140826101107.GC32315@leverpostej> <20140827103432.64927C409CB@trevor.secretlab.ca> <20140827144403.GB13850@arm.com> <53FE05AE.9000406@wwwdotorg.org> <53FE07BE.7000809@ahsoftware.de> <53FE0966.5020206@wwwdotorg.org> <53FED13C.4070606@ahsoftware.de> <20140828092308.GA31111@arm.com>
In-Reply-To: <20140828092308.GA31111@arm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.08.2014 11:23, schrieb Catalin Marinas:
> On Thu, Aug 28, 2014 at 07:50:36AM +0100, Alexander Holler wrote:

>> And I wonder how the ACPI world solves that problem. My guess would be
>> hardcoded stuff in the firmware-blob (BIOS), just like it happened with
>> board files, but I've never seen BIOS code and my knowledge about ACPI
>> is almost zero. ;)
>
> ACPI doesn't even attempt to solve such problems at the OS level. SoCs
> aimed at ACPI should have simple hardware configuration (from a Linux
> perspective) initialised by firmware (e.g. clocks) and devices living on
> a standard bus like PCIe. If a SoC requires specific low-level code to
> initialise the hardware in a specific order (other than architected
> peripherals like GIC, timers; e.g. MFD devices), we should deem it
> unsuitable for ACPI.
>
> ACPI should only be used by vendors who know exactly why they need and
> how to implement it properly and not just because the marketing
> department told them to (it would also be nice if the Linux kernel
> community was informed about such reasons).

Hmm, Jon Masters from Red Hat sounds too like UEFI/ACPI is the way to go.

But maybe he's right and hiding ugly code in proprietary/binary firmware 
blobs where no one can see and criticize it is really the way to go.

Personally I think it's a way back to the past ("when everything was 
better", at least that is what most human brains do like to suggest) and 
just a dream. And I don't believe that the stuff which was and is hidden 
away always just works and doesn't need fixes (one can't do themself). 
In my humble opinion that's a nice but wrong myth and doesn't take into 
consideration that HW (and SW) gets more and more complicated too (and 
thus more faulty).

And even the biggest companies already have problems to produce stuff
which just works (they just employ humans too), not to speak from 
smaller board vendors. So it's much better to keep the source as visible 
as possible to as much people as possible (in the OS) and not to rely on 
some binary blob as most BIOSes are.

Regards,

Alexander Holler

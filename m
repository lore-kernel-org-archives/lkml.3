Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbaH1JXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:23:46 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:34124 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965230AbaH1JXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:23:43 -0400
Date: Thu, 28 Aug 2014 10:23:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
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
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140828092308.GA31111@arm.com>
References: <20140826084208.AE5F0C40989@trevor.secretlab.ca>
 <20140826084922.GG17263@ulmo>
 <53FC566C.30904@ahsoftware.de>
 <20140826101107.GC32315@leverpostej>
 <20140827103432.64927C409CB@trevor.secretlab.ca>
 <20140827144403.GB13850@arm.com>
 <53FE05AE.9000406@wwwdotorg.org>
 <53FE07BE.7000809@ahsoftware.de>
 <53FE0966.5020206@wwwdotorg.org>
 <53FED13C.4070606@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FED13C.4070606@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 07:50:36AM +0100, Alexander Holler wrote:
> Am 27.08.2014 18:37, schrieb Stephen Warren:
> > Of course, there are probably cases where we could/should add some more
> > phandles/... and likewise cases where we shouldn't. That's why detailed
> > research is needed.
> 
> Just because I'm curious, I wonder how this research does or shoud look 
> like.
> 
> Defered probes did come to light with 3.4, that was more than 2 years 
> ago. Ok, most people (like me) just noticed it during the last months 
> when they switched to DT and have run into a problem (the deferred probe 
> mechanism is an error-message killer), but some must have seen it 
> already 2 years ago.
> 
> And I wonder how the ACPI world solves that problem. My guess would be 
> hardcoded stuff in the firmware-blob (BIOS), just like it happened with 
> board files, but I've never seen BIOS code and my knowledge about ACPI 
> is almost zero. ;)

ACPI doesn't even attempt to solve such problems at the OS level. SoCs
aimed at ACPI should have simple hardware configuration (from a Linux
perspective) initialised by firmware (e.g. clocks) and devices living on
a standard bus like PCIe. If a SoC requires specific low-level code to
initialise the hardware in a specific order (other than architected
peripherals like GIC, timers; e.g. MFD devices), we should deem it
unsuitable for ACPI.

ACPI should only be used by vendors who know exactly why they need and
how to implement it properly and not just because the marketing
department told them to (it would also be nice if the Linux kernel
community was informed about such reasons).

-- 
Catalin

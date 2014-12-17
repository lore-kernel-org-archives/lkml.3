Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaLQOc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:32:26 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:63542 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLQOcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:32:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
Cc: Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        mark.rutland@arm.com, a.zummo@towertech.it, sbranden@broadcom.com,
        pawel.moll@arm.com, devicetree@vger.kernel.org,
        ijc+devicetree@hellion.org.uk, Arun Ramamurthy <arunrama@broadcom.com>,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        galak@codeaurora.org, rtc-linux@googlegroups.com
Subject: Re: [PATCHv1] rtc: bcm-iproc: Add support for Broadcom iproc rtc
Date: Wed, 17 Dec 2014 15:31:25 +0100
Message-ID: <1603624.EMYvBCWhuM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5490A9FC.6030305@broadcom.com>
References: <1418757750-3628-1-git-send-email-arun.ramamurthy@broadcom.com> <549095CA.7090505@broadcom.com> <5490A9FC.6030305@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:uPDQG68vqKhesXJWzQQf4YARArbEzwTWbjA/XrFqqcVcdq92NvO
 JlyhbFwyTVQAngE/+iv++nY9B0dfNaBmsGxnQQdQU3sckN7GzntaRk68lyCy3ZlOU6g3nRk
 bYoxWC3czw4k9CiN7Xj9vTzenq8INIqoyQmYJAUfnHDEreUPPEUtB8tJBg4qlAbIiMne7HL
 f0ssRwFmIHq+Ob7pFixHA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2014 13:54:04 Arun Ramamurthy wrote:
> On 14-12-16 12:27 PM, Ray Jui wrote:
> > On 12/16/2014 12:19 PM, Arnd Bergmann wrote:
> >>
> >> It sounds like CRMU is some other unit aside from the RTC. Could this
> >> be something like a generic system controller? I think it should
> >> either have its own driver or use the syscon logic if that is what
> >> this is.
> >>
> > Giving that CRMU has scattered, miscellaneous control logic for multiple
> > different peripherals, it probably makes more sense to use the syscon
> > logic here.
> >
> Arnd, thanks for the feedback. If I was to write a separate driver for 
> the CRMU, I would have to export certain functions and create an api 
> that only this RTC driver would use. I am not sure that is efficient or 
> required. What is your opinion?
> Would it be better if I use the syson api in my current driver and move 
> the CRMU registers to separate syscon device tree entry?
> 

This is something that's normally up to the platform maintainers, depending
on what works best for a given SoC. If you have a control block that
wants to export the same high-level API for multiple drivers, that's
fine, but if literally every register does something different, a syscon
driver works best.

It's also possible that some of the functions of the CRMU already have
abstractions, like system-reset, device-reset, regulator or clock support.
In that case, you can still use syscon but have the more other drivers
use that for accessing the registers.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab3JKGxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:53:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40500 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab3JKGxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:53:53 -0400
Message-ID: <5257A05B.2070906@ti.com>
Date: Fri, 11 Oct 2013 12:23:15 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Mark Rutland <mark.rutland@arm.com>, dt list <devicetree@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: dts: omap5-uevm: remove always_on, boot_on from
 smps10_out1
References: <1381402195-29257-1-git-send-email-kishon@ti.com> <20131010141949.GA13277@kahuna> <52579723.6080209@ti.com> <CAGo_u6odWJ9UKwgaVu2YZzZKuYbveBoGDf99L=rJoK1-9KJ0SA@mail.gmail.com>
In-Reply-To: <CAGo_u6odWJ9UKwgaVu2YZzZKuYbveBoGDf99L=rJoK1-9KJ0SA@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 11 October 2013 12:00 PM, Nishanth Menon wrote:
> On Fri, Oct 11, 2013 at 1:13 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>
>>> regulator-boot-on indicates that PMIC enables it by default as part of
>>> OTP or some internal behavior -> Looking at the measurements done on
>>> uEVM and OTP information -> regulator-boot-on should be kept here.
>>
>> No. Actually I don’t want PMIC to enable it by default. I want the palmas-usb
>> driver to handle it.
>> Enabling it by default makes palmas-usb to detect VBUS interrupt. This should
>> ideally be detected only when you connect a host cable.
>> Btw I didn't exactly get why you want regulator-boot-on should be kept here.
> 
> binding description states:
> - regulator-boot-on: bootloader/firmware enabled regulator
> Further info: include/linux/regulator/machine.h
> * @boot_on: Set if the regulator is enabled when the system is initially
> *           started.  If the regulator is not enabled by the hardware or
> *           bootloader then it will be enabled when the constraints are
> *           applied.
> 
> What that means is that it is enabled by firmware/bootloader (in our
> case One Time Program {OTP} inside Palmas) when the system switches on
> even before the kernel starts. and we know SMPS10 is autoenabled by
> Palmas OTP configuration even before first instruction in A15
> executes.

Not sure about that. Please note SMPS10 has two outputs OUT1 and OUT2 and I
tend to think that it might be OUT2 that's getting enabled by the OTP.
> 
> I think you misunderstand this to mean that you'd like the regulator
> to be *switched on* automatically at kernel boot by regulator
> framework - there is no reasoning why we'd want such a binding since
> we'd expect drivers to do their job of requesting and enabling
> regulators on need..

The comment you just quoted tells it enables the regulator if its not enabled
by hardware. "If the regulator is not enabled by the hardware or bootloader
then it will be enabled when the constraints are applied." At-least that's what
I understood from that comment.

Also from our experiments it doesn't look like SMPS10_OUT1 is enabled by the
OTP and it gets enabled when we have *regulator-boot-on* constraints.

Thanks
Kishon

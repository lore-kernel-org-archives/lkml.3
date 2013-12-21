Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3LUCPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:15:39 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:10649 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3LUCPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:15:34 -0500
X-IronPort-AV: E=Sophos;i="4.95,525,1384329600"; 
   d="scan'208";a="4514733"
Message-ID: <52B4F9BD.1010100@broadcom.com>
Date: Fri, 20 Dec 2013 18:15:25 -0800
From: Sherman Yin <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Heiko St?bner <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/6] pinctrl: Make PINCTRL selectable by defconfig/menuconfig
References: <1381174108-25168-1-git-send-email-syin@broadcom.com> <20131217001842.GB3840@sonymobile.com> <CACRpkdY-MM7OoMq_L90YRADy=oaDoV1wAOccVz90LqfRfEh=3Q@mail.gmail.com> <201312202158.34805.arnd@arndb.de>
In-Reply-To: <201312202158.34805.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-20 12:58 PM, Arnd Bergmann wrote:
> On Friday 20 December 2013, Linus Walleij wrote:
>> On Tue, Dec 17, 2013 at 1:18 AM, Bjorn Andersson
>> <bjorn.andersson@sonymobile.com> wrote:
>>
>>> No matter how we build the individual pinctrl drivers we will always
>>> need the pinctrl framework in a multi-soc zImage; so I can't see that
>>> we gain anything from being able to compile PINCTRL as a module.
>>
>> I discussed this matter with Christian on IRC and I believe we could
>> basically do "select PINCTRL" on ARCH_MULTIPLATFORM as the
>> vast majority of multiplatforms appear to be using this anyway, this
>> would make the submenu for pin control pop up in menuconfig
>> for this, and make it possible to move different subdrivers to modules
>> if desired.
>>
>> MULTIPLATFORM does not seem to be about saving footprint bytes
>> on a very fine-granular level anyway, more about doing the module
>> loading/unloading approach to footprint.
>
> Let's review the list of platforms that don't select PINCTRL. There
> are some platforms that are indeed sensitive about memory footprint,
> and I promised people that converting to multiplatform won't cause
> a significant increase in kernel binary size as long as no other
> platforms are enabled.
>
> 	Arnd
>

Ok, for this driver, I'll just select PINCTRL under the ARCH_BCM_MOBILE. 
  We can move this to ARCH_MULTIPLATFORM once we're sure this is okay 
for other platforms.

Regards,
Sherman

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaJVRMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:12:18 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:32853 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaJVRMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:12:16 -0400
X-IronPort-AV: E=Sophos;i="5.04,770,1406617200"; 
   d="scan'208";a="48895481"
Message-ID: <5447E56D.6000006@broadcom.com>
Date: Wed, 22 Oct 2014 10:12:13 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: Re: [PATCH v5 1/6] ARM: cygnus: Initial support for Broadcom Cygnus
 SoC
References: <1413341936-17606-2-git-send-email-sbranden@broadcom.com> <38587325.kaAxCWAsmL@wuerfel> <5446F61C.8060400@broadcom.com> <12157660.uOkg5nk8Dq@wuerfel>
In-Reply-To: <12157660.uOkg5nk8Dq@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-22 01:22 AM, Arnd Bergmann wrote:
> On Tuesday 21 October 2014 17:11:08 Scott Branden wrote:
>> OK, I will remove the "iProc SoC based Machine types".  This was
>> grouping all iProc based SoCs under one menu and parallels what the
>> existing "Broadcom Mobile Soc Support" menu does.
>>
>> I can create another patch removing the "Broadcom Mobile SoC Support"
>> menu if the ARM Maintainer now want all Broadcom devices are supposed to
>> be contained in a single level?
>
> Sounds good, I missed that other menu going in.
I will add another patch to my set to correct this.
>
> It can make sense to add 'comment' statements if you want to separate the
> families.
Thanks - I will add this to my patchset.
>
> I also noticed that there are a few configuration options that at first
> seem pointless: ARCH_BCM_MOBILE_L2_CACHE and ARCH_BCM_MOBILE_SMP. I wonder
> if it ever makes sense to disable these when the common options (CACHE_L2X0
> and SMP) are enabled for another SoC. I'd normally like to see these as
> hidden options that are always on whenever the core support for those
> features is enabled, to avoid confusing users as well as bugs from the
> combinatorial explosion.
I can clean up all but ARCH_BCM_MOBILE_L2_CACHE.  This one is 
intertwined with SMC support and it looks like they want the option to 
turn on and off this feature.  This L2/Trustzone support will need to be 
cleaned up at a later time.  I heard Russell King says the PL310 cache 
code will be changing again soon.  When I add PL310 Trustzone support 
for the Cygnus SoC I can have a look at cleaning it up for the 
Mobile/Kona base SoCs at the same time.
>
> 	Arnd
>


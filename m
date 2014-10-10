Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaJJTLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:11:45 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:23007 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaJJTLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:11:43 -0400
X-IronPort-AV: E=Sophos;i="5.04,693,1406617200"; 
   d="scan'208";a="47788721"
Message-ID: <54382F69.3060607@broadcom.com>
Date: Fri, 10 Oct 2014 12:11:37 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
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
Subject: Re: [PATCH V4 5/7] ARM: dts: Enable Broadcom Cygnus SoC
References: <1412894671-5921-6-git-send-email-sbranden@broadcom.com> <6003834.vKPhBNUdsz@wuerfel>
In-Reply-To: <6003834.vKPhBNUdsz@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-10 03:08 AM, Arnd Bergmann wrote:
> On Thursday 09 October 2014 15:44:29 Scott Branden wrote:
>> +
>> +               lcpll: lcpll@0301d02c {
>> +                       #clock-cells = <0>;
>> +                       compatible = "brcm,cygnus-lcpll-clk";
>> +                       reg = <0x0301d02c 0x1c>;
>> +                       clocks = <&osc>;
>> +               };
>> +
>> +               genpll: genpll@0301d000 {
>> +                       #clock-cells = <0>;
>> +                       compatible = "brcm,cygnus-genpll-clk";
>> +                       reg = <0x0301d000 0x2c>,
>> +                                 <0x180AA024 0x4>,
>> +                                 <0x0301C020 0x4>;
>> +                       clocks = <&osc>;
>> +               };
>> +
>
> To be honest, I'm not too happy about the way you specify a single
> register for each clock as a global 'reg' property.
I'm not happy with this either.  Will rework.
>
> Presumably each of these registers is part of an IP block that does
> multiple things, so it would be better to start out with a binding
> for each IP block. How many of these blocks are used for clocks, and
> what do they do?
Clocks are a little scattered in the chip and don't make a lot of sense 
for easy software programming.  Will look at how to change bindings so 
they are flexible to work on other generations.
>
> 	Arnd
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaJHSpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:45:50 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:38625 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaJHSps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:45:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,679,1406617200"; 
   d="scan'208";a="47586861"
Message-ID: <5435865A.4070702@broadcom.com>
Date: Wed, 8 Oct 2014 11:45:46 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        "Mike Turquette" <mturquette@linaro.org>,
        Alex Elder <elder@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, <devicetree@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>, <linux-kernel@vger.kernel.org>,
        Jonathan Richardson <jonathar@broadcom.com>,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus
 SoC
References: <1412746025-11998-2-git-send-email-sbranden@broadcom.com> <10762659.VISiZ3vSSN@wuerfel> <543565DC.8010704@broadcom.com> <34012512.W8VifyXY4H@wuerfel>
In-Reply-To: <34012512.W8VifyXY4H@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-10-08 11:12 AM, Arnd Bergmann wrote:
> On Wednesday 08 October 2014 09:27:08 Scott Branden wrote:
>> On 14-10-08 06:28 AM, Arnd Bergmann wrote:
>>> On Wednesday 08 October 2014 05:27:24 Scott Branden wrote:
>>>>>
>>>>> I don't think you need per-board config options. The main option
>>>>> above should be enough.
>>>> This is not a per-board config option.  This is actually a per-SoC
>>>> uArchtecture selection.  More major uArchectures will be added to the
>>>> IPROC.  Will Change comment to "Support Broadcom Cygnus SoC"
>>>
>>> Ok, sounds fine, but remove ARCH_BCM_IPROC then. There should be
>>> no need for a three-level deep hierarchy (BCM -> IPROC -> CYGNUS)
>>>
>> I do not need a 3-deep hierarchy, I need a 2-deep hierarchy for IPROC
>> and CYGNUS (and future SoCs that have IPROC Architecture in common).  I
>> can move IPROC out of the mach-bcm directory if you like a create a new
>> directory?  But it looks like the purpose of mach-bcm is to consolidate
>> all Broadcom chipsets in it?
>
> Yes, better leave it all in mach-bcm. You really shouldn't need much
> code at all that is soc specific, so adding new directories is not
> encouraged. We have some platforms that need no code at all, and on
> arm64 that is required.
>
> Isn't Northstar also IPROC? That one didn't seem to need the symbol.
Yes, Northstar is an older version of IPROC.  We may be able to 
consolidate it under the IPROC family as we upstream additional SoCs and 
drivers.  Have the commonality with ARCH_BCM_IPROC will allow this.
>
> Could you make ARCH_BCM_IPROC a silent symbol that is just selected
> by each SoC family specific symbol?
OK, I will make ARCH_BCM_IPROC a silent symbol.
>
> 	Arnd
>


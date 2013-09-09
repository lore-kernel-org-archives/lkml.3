Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3IINvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:51:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37667 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3IINv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:51:29 -0400
Message-ID: <522DD251.2030607@arm.com>
Date: Mon, 09 Sep 2013 14:51:13 +0100
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matt Porter <matt.porter@linaro.org>
CC: Koen Kooi <koen@dominion.thruhere.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "bcousson@baylibre.com" <bcousson@baylibre.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
References: <1378638746-10627-1-git-send-email-koen@dominion.thruhere.net> <20130909133059.GD10973@ohporter.com>
In-Reply-To: <20130909133059.GD10973@ohporter.com>
X-OriginalArrivalTime: 09 Sep 2013 13:51:25.0613 (UTC) FILETIME=[ACFFB5D0:01CEAD63]
X-MC-Unique: 113090914512705101
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 09/09/13 14:31, Matt Porter wrote:
> On Sun, Sep 08, 2013 at 01:12:26PM +0200, Koen Kooi wrote:
>> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
>> so create a common dtsi both can use.
>>
>> IMPORTANT: booting the existing am335x-bone.dts will blow up the HDMI transceiver
>> after a dozen boots with an uSD card inserted because LDO will be at 3.3V instead
>> of 1.8.
>>
>> MMC support for AM335x still isn't in, so only the LDO change has been added.
>>
>> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
>
> Tested-by: Matt Porter <matt.porter@linaro.org>
>
> Works fine for me on tip and 3.11. I did notice a regression in musb (worked
> on 3.11, now failing to probe but this is not related to your new dts as it
> happens on am335x-bone.dts too, assuming merge window volatility). One nit,
> git-am picked up a whitespace error on that extra line at EOF so you should
> trim that out.
>
> Only thing is...for a clear bug like this that will destroy hardware, it
> should be marked Cc: stable@vger.kernel.org to be picked up in stable.
>

If I've understood Koen correctly then what he's saying is that if you 
*were* to use the current (before this patch) am335x-bone.dts on a 
Beagle Bone Black (which would be wrong, as that's not the board you 
have...) then things would break.

I don't see that this patch fixes that - as far as I can see, even after 
the patch, using am335x-bone.dts with a Bone Black will risk the damage?

If so, I don't think this is a 'stable fix' kind of thing, as it doesn't 
actually fix the problem?

Koen - is there a way for a booting kernel to detect which board it is 
on and avoid any potential damage if someone gives it the wrong DT?

Jonny

> -Matt
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>



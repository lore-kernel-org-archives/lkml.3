Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3FYVky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:40:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43199 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3FYVkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:40:53 -0400
Message-ID: <51CA0E62.2080403@wwwdotorg.org>
Date: Tue, 25 Jun 2013 15:40:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: James Hogan <james.hogan@imgtec.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbne?= =?ISO-8859-1?Q?r?= 
	<heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
References: <201306251455.01540.heiko@sntech.de> <201306251456.36499.heiko@sntech.de> <51C99581.2010403@imgtec.com> <201306251521.55634.heiko@sntech.de> <51C99AB5.1080002@imgtec.com> <CACRpkdbdwvmBYFX=ppdM_RmGwyTcWVeTCMj60F4sh6YEVRE2Uw@mail.gmail.com> <51C9A039.4090804@imgtec.com> <CACRpkda--Thd9sop2FRUwTKiXnePNyg38ajxAZVvKkROrQsGkw@mail.gmail.com>
In-Reply-To: <CACRpkda--Thd9sop2FRUwTKiXnePNyg38ajxAZVvKkROrQsGkw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 09:39 AM, Linus Walleij wrote:
> On Tue, Jun 25, 2013 at 3:50 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> On 25/06/13 14:32, Linus Walleij wrote:
> 
>>> Patches adding it back in with SI measures will be welcomed!
>>
>> Okay.
>>
>> So the most descriptive documentation I can find for the slew rate in
>> the TZ1090 pin config hardware is basically:
>>
>> 0: slow (half frequency)
>> 1: fast
>>
>> Sounds like this pretty much precludes it from having a generic DT
>> binding unless it can be mapped to some physical value, so I'll add a
>> tz1090,slew-rate and use PIN_CONFIG_END+1 instead of PIN_CONFIG_SLEW_RATE.
> 
> Okay... ut the Nomadik pin controller incidentally have a
> similar definition: NMK_GPIO_LOWEMI. By slashing the
> slew rate in half the EMI is of course reduced so that was
> another name for the same thing.
> 
> Maybe this is something that should just be boolean?
> 
> slewrate-reduced-slope;

Tegra has, IIRC, 4 different slew rates. I'm not sure that a
Boolean/dual-state value would be appropriate here; it'd be limited to
supporting some arbitrary cases rather than being something generic.


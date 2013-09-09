Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3IIXpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:45:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43855 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab3IIXpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:45:05 -0400
Message-ID: <522E5CF2.3080108@ti.com>
Date: Mon, 9 Sep 2013 18:42:42 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>
CC: Kevin Hilman <khilman@linaro.org>, <bcousson@baylibre.com>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <olof@lixom.net>
Subject: Re: [PATCH] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
References: <1378736961-21005-1-git-send-email-koen@dominion.thruhere.net> <87zjrm81dl.fsf@linaro.org> <BBAC0939-A4F9-4FEA-B137-0307D8787DC3@dominion.thruhere.net> <522E1325.8050906@ti.com> <41952E65-1037-4117-A1AE-8310FED59E3A@dominion.thruhere.net> <522E18C0.9010909@ti.com> <522E269B.7000802@ti.com> <73968C64-F0B0-4ED6-82B8-BD1966ED9D84@dominion.thruhere.net> <522E2B9E.8050404@ti.com>
In-Reply-To: <522E2B9E.8050404@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 03:12 PM, Joel Fernandes wrote:
> On 09/09/2013 03:00 PM, Koen Kooi wrote:
>>
>> Op 9 sep. 2013, om 21:50 heeft Joel Fernandes <joelf@ti.com> het volgende geschreven:
>>
>>> On 09/09/2013 01:51 PM, Joel Fernandes wrote:
>>>> On 09/09/2013 01:43 PM, Koen Kooi wrote:
>>>>>
>>>>> Op 9 sep. 2013, om 20:27 heeft Joel Fernandes <joelf@ti.com> het volgende geschreven:
>>>>>
>>>>>> On 09/09/2013 10:51 AM, Koen Kooi wrote:
>>>>>>>
>>>>>>> Op 9 sep. 2013, om 17:23 heeft Kevin Hilman <khilman@linaro.org> het volgende geschreven:
>>>>>>>
>>>>>>>> Koen Kooi <koen@dominion.thruhere.net> writes:
>>>>>>>>
>>>>>>>>> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
>>>>>>>>> so create a common dtsi both can use.
>>>>>>>>>
>>>>>>>>> IMPORTANT: booting the existing am335x-bone.dts will blow up the HDMI transceiver
>>>>>>>>> after a dozen boots with an uSD card inserted because LDO will be at 3.3V instead
>>>>>>>>> of 1.8.
>>>>>>>>>
>>>>>>>>> MMC support for AM335x still isn't in, so only the LDO change has been added.
>>>>>>>>>
>>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>>>
>>>>>>>>> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
>>>>>>>>> Tested-by: Tom Rini <trini@ti.com>
>>>>>>>>> Tested-by: Matt Porter <matt.porter@linaro.org>
>>>>>>>>
>>>>>>>> I guess the subject should've included v5?
>>>>>>>
>>>>>>> Yes, I blame it on being monday :)
>>>>>>
>>>>>> The series you're posting will require rebasing on the current MMC DT series
>>>>>> that is being discussed last couple of weeks on the mailing list which were
>>>>>> waiting until now as DMA support was missing. Now that DMA support is pulled in,
>>>>>> it is safe to apply those patches so I will be reposting them shortly.
>>>>>>
>>>>>> Please hold off any changes until those patches are posted. This will avoid
>>>>>> unnecessary conflicts.
>>>>>
>>>>> Or you can rebase on top of this patch since it has no dependencies *and* fixes blowing up boards. FWIW, git-rebase, git-cherry-pick and git-am -3 track the rename in my patch just fine.
>>>>>
>>>>
>>>> That's fair enough, since  Kevin Acked and Benoit is pulling it, I'm fine with
>>>> rebasing on top of it and we avoid any merge conflicts.
>>>>
>>>
>>> I noticed - there were still some comments from Felipe on the v4 series of this
>>> patch regarding RF cape and HDMI may be breaking it. How are you addressing that?
>>
>> Capes will never go into the .dts and HDMI support needs some serious patching before it can get enabled in the DT. And the RF cape isn't being sold since it has no sw support. No need to worry about things in the 3.15/3.16 timeframe. Unless you want this LDO3 fix not to go in ASAP.
>>
>> Joel, is there anything relevant *right now* blocking this patch going in? If not, please test it and add your Tested-by: line.
>>
> 
> We don't merge things in hurry and focus is to do things the right way.. I just
> want to make sure that all possible comments have been addressed.
> 
> Otherwise patch looks OK and hope everyone else thinks so too. I am dealing with
> some merge conflicts right now with my series on top of this though, but they
> should be easy enough to fix up. That's delaying my testing, but otherwise as
> such I don't have any objection to this patch (provided the conclusion is that
> all comments have been addressed..). Thanks!

Koen,

One note though, since I don't use HDMI (or BBB much for that matter), I was ok
with taking a risk of upping the ldo3 regulator voltage to 3.3v on my board
which I needed to do to get to the boot prompt.

I applied my AM335x DMA and MMC patches and tried to boot with rootfs as MMC1.

With 1.8v, I get the following during boot:
[    2.236043] mmc0: host doesn't support card's voltages
[    2.241659] mmc0: error -22 whilst initialising SD card

That's strange because I do have an SDHC card. With 3.3v it works fine.

I will add a note about this to my series. Since this more of an MMC issue than
anything, and your patch series doesn't enable MMC, you can add my tested-by:

Tested-by: Joel Fernandes <joelf@ti.com>

Later on, the regulator voltage may need to be tweaked for MMC support.

Regards,

-Joel

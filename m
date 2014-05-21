Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaEUKRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:17:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:60909 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUKRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:17:13 -0400
Message-ID: <537C7D25.6060705@atmel.com>
Date: Wed, 21 May 2014 12:17:09 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: DT for 3.16 #2
References: <1400059162-630-1-git-send-email-nicolas.ferre@atmel.com> <20140520055041.GO18956@quad.lixom.net> <537B727C.5080404@atmel.com> <20140520164746.GA601@quad.lixom.net>
In-Reply-To: <20140520164746.GA601@quad.lixom.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/2014 18:47, Olof Johansson :
> Hi,
> 
> On Tue, May 20, 2014 at 05:19:24PM +0200, Nicolas Ferre wrote:
>> On 20/05/2014 07:50, Olof Johansson :
>>> On Wed, May 14, 2014 at 11:19:22AM +0200, Nicolas Ferre wrote:
>>>> Arnd, Olof, Kevin,
>>>>
>>>> More DT material for AT91. Some fixes that apply on what was merged for 3.15
>>>> but that are not very critical.
>>>> The other patches are feature additions to old or very recent product/board:
>>>> at91sam9261 or sama5d3 Xplained.
>>>>
>>>> Thanks, best regards,
>>>>
>>>> The following changes since commit 27a96a0364787d2b41d2a72d08143d95263e1b07:
>>>>
>>>>   ARM: at91: sama5d3: clock for ssc from rk pin (2014-04-18 22:43:44 +0200)
>>>>
>>>> are available in the git repository at:
>>>>
>>>>   git://github.com/at91linux/linux-at91.git tags/at91-dt2
>>>>
>>>> for you to fetch changes up to a93f9c88b7701d1c4c3b22d39d64a408f000a6ef:
>>>>
>>>>   ARM: at91/dt: at91-sama5d3_xplained: add the regulator device node (2014-05-12 16:48:54 +0200)
>>>
>>> Merged, but:
>>>
>>>>  arch/arm/boot/dts/at91-sama5d3_xplained.dts |  62 +++++++++++++++
>>>>  arch/arm/boot/dts/at91sam9261.dtsi          | 114 ++++++++++++++++++++++++++--
>>>>  arch/arm/boot/dts/at91sam9rl.dtsi           |   7 +-
>>>>  arch/arm/boot/dts/sama5d3.dtsi              |  78 +++++++++++++++++++
>>>
>>> Grmbl. I remember being somewhat annoyed that you didn't use at91 prefix
>>> when you introduced the sama5d3 dtsi files, but please don't start using
>>> it on a random board like this, especially when other boards just use
>>> the sama5d3_<board>.dts format.
>>
>> Well, I don't understand completely. Since our discussion during 3.10
>> merge window ([GIT PULL] at91: DT changes for 3.10 #2), I try to conform
>> to this rule:
>>
>> 1/ all pre-3.10 and 3.10 device tree file names stay unchanged
>> -> sama5d3.dti (SoC)
>> -> sama5d35ek.dts (board)
>>
>> 2/ all *SoC* DT files conform to their marking:
>> at91sam9263.dtsi
>> at91sam9rl.dtsi
>> sama5d3.dtsi, sama5d36.dtsi
>> sama5d4.dtsi, sama5d46.dtsi (maybe in the future, who knows...)
>>
>> 3/ all post-3.10 *boards* have the "at91-" prefix, whether they are
>> populated with sam9 or sama5:
>> at91-ariag25.dts (since 3.10, using a at91sam9g25)
>> at91-qil_a9260.dts (since 3.14, using at91sam9260)
>> at91-sama5d3_xplained.dts (since 3.14, using sama5d36)
>>
>> The rule for AT91 has never been to prefix the board DT filename with
>> the name of the SoC or SoC family.
> 
> So, going back and looking at the discussion from a year ago, I think the
> disconnect was in what consistency we were looking for. Yes, we would have
> preferred to prefix the sama5d3* dts/dtsis with at91, and you even
> offered to do it. ;-) But I think even more important for sanity is
> to stay consistent with how we handle all platforms, which is that the
> board dts files are prefixed with the SoC name.
> 
> In the past, we've had cases where this didn't happen, but these days we have
> tried to be very consistent on it. I.e. omap3*, exynos<##>*, etc.

Okay, but once again, I tried to deal with the existing files, not break
any user's habit, before any convention had been clearly established,
and now... we are reaching a deadlock having to re-consider again our DT
filenames?

> So, if you have at91- as a prefix, have the SoC as the second component. But
> that gets awkward too, so I would juts use the current SoC dtsi as the prefix
> at91sam9263-<boardname>.dts, or sama5d35_<boardname>.dts.
> 
>>> Care to fix this up in time for 3.16 merge window?
>>
>> Well, I do not know what to fix as the files were already present in
>> mainline before this kernel revision and that I am a little bit
>> reluctant to change file names after they are merged in mainline.
>>
>> Now, can we keep the current policy described above (somehow weird, I
>> admit) for future SoCs and boards?
> 
> It is unfortunate that I didn't catch this for 3.14 so that name has been
> there in a release. I guess the least disruptive thing for now would be
> to change over to use the SoC dtsi prefix for any new board files from
> here on out, and treat at91-sama5d3_xplained as a one-time thing.

That is not only about sama5d3, what about sam9-based boards? Several of
them already have this "at91-" prefix (and not a soc prefix).

So this will introduce another temporary naming convention for these
files which are actually used by people: everyone will be puzzled.

Okay, there are two ways to escape this situation:
1/ change nothing and conform to what I stated above. It is more like
   finding a rationale to an existing situation than a real neat
   policy, but hey, "nobody's perfect".
2/ change *everything* in AT91 DT file naming with a schema that
   we will have to validate with care (<soc family> or <soc>,
   "_" or "-", what about boards with modules, etc.).
   That will certainly disturb many of our users without a real benefit.

This directory is flat, the board names are chosen by companies and
people that we do not control, a user tend to like finding his preferred
board dtb file unchanged from a kernel revision to another...
Well all this lead me to think that we don't have to loose too much time
thinking about a new strict convention for this file naming or changing
all this once again just for the sake of it.

Other SoC maintainers beautifully designed from the beginning the naming
scheme of their DT files, fine. AT91 did not and forgive me but when
opening arch/arm/boot/dts/Makefile file and seeing some file names, I'm
not ashamed. Moreover, now that I said to everybody since 3.10 to prefix
their *board* name with "at91-", I have to say something else, I don't
think it is worth it.

Bye,
-- 
Nicolas Ferre

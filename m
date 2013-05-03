Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975Ab3ECSD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 14:03:29 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42294 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab3ECSD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 14:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <5182B557.4040804@wwwdotorg.org>
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
	<516EEAA0.10906@wwwdotorg.org>
	<20130418090310.GA17636@ab42.lan>
	<CACRpkdZd0_W432od5565phhUcJMRWiV9vXX4QVF4osKkxstC0Q@mail.gmail.com>
	<20130429161725.GB30136@ab42.lan>
	<5182B557.4040804@wwwdotorg.org>
Date: Fri, 3 May 2013 20:03:27 +0200
Message-ID: <CACRpkdaxO0q_P2wJFy3zv4F-QM9dZk54qW8ft350XqcBt1Gr1w@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinmux: Add TB10x pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 8:49 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/29/2013 10:17 AM, Christian Ruppert wrote:
>>>
>>> So if this is what you want to achieve, just use the same number
>>> as in your datasheet in the pin number -> problem solved.
>>
>> The problem is that we must support several products which are basically
>> different packaging options of the same chip (or simplified versions
>> thereof). Not all of those products will have the same number of pins
>> and as a consequence, data sheet pin numbering will also be different.
>> The port names are going to remain the same for all products, however.
>> Some of the ports are just not going to be physically available in some
>> or the products. Sorry if that wasn't clear from my previous mail.
>
> It sounds like you can use the exact same numbering scheme for all the
> different packaging options; it's just that some of the pin numbers
> simply won't exist on some of the packaging options, so while defined by
> the DT binding, it simply won't make sense to use them?
>
> Certainly, Tegra20 has two packaging options, and the pinctrl driver for
> it has zero knowledge of this. Perhaps we're just lucky though. I guess
> the Tegra TRM doesn't define any "Pin number" (just "pin name") for the
> pins, so there's no possibility of the same "number" meaning different
> things in the two packages, so perhaps we're just getting lucky here.

I am certain it must be possible to come up with something reasonable
here, especially since this is using the device tree.

In U300 we had something like 4 different packaging types, all with
different names on the pins, however I could avoid the entire
issue by using pad numbers instead, i.e. the numbers of the pads/fingers
on the silicon die inside the chip.
(Documentation/pinctrl.txt contains hints on this.)

It seems like your situation is similar.

And since you work for Abilis I assume you can access such low-level
documentation and come up with a numbering scheme based on
something that does not vary with packaging.

And if you can't, and since you're using device tree, come up with
a per-packainging pin numbering, put it into a special .dtsi file that
you layer over the core SoC .dtsi file just to get these numbers,
and then use the apropriate packaging .dtsi in yout eventual
machine .dts file.

Yours,
Linus Walleij

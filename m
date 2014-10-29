Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaJ2JI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:08:28 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63074 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbaJ2JIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:08:24 -0400
Message-ID: <5450AE6F.8010102@linux.com>
Date: Wed, 29 Oct 2014 10:07:59 +0100
From: Matthias Klein <matthias.klein@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        linux-rpi-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1414457566-31802-1-git-send-email-matthias.klein@linux.com> <54504407.3090700@wwwdotorg.org>
In-Reply-To: <54504407.3090700@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 29.10.2014 um 02:33 schrieb Stephen Warren:
> On 10/27/2014 06:52 PM, Matthias Klein wrote:
>> The model B and B+ differ in the GPIO lines for ACT and PWR led.
>> The PWR led on the B+ model is active low.
> This new file is almost identical to bcm2835-rpi.dts. Perhaps we can use
> some include files to share the common portions so they aren't
> duplicated. Roughly:
>
> * Move all the common content from bcm2835-rpi.dts into bcm2835-rpi.dtsi.
>
> * Update bcm2835-rpi.dts to include bcm2835-rpi.dtsi to get all the
> common parts, and add the few lines of differences.
>
> * Update this patch similarly.
>
> Does that make sense?
Yes, I will work on such a patchset.

>
> A couple changes to this patch and the existing bcm2835-rpi.dts might
> reduce the differences even further, leading to more common code in
> bcm2835-rpi.dtsi:
>
> - Add the PWR LED to bcm2835-rpi-b.dts, if appropriate.
> - Add the I2S pinmux settings for B+ too.
>
>> diff --git a/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
> ...
>> +&mmc {
> That label doesn't exist; it should be &sdhci. Consequently:

Sorry, I based my patch on the wrong tree. I used 
https://github.com/pietrushnic/rpi-dt-linux/tree/rpi-3.17.y which 
contains non upstream commits.

Which tree should I use in general for work on the BCM2835? Is 
linux-next the right tree?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934744AbaJ2Qj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:39:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40174 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934242AbaJ2Qj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:39:56 -0400
Message-ID: <54511876.1040301@wwwdotorg.org>
Date: Wed, 29 Oct 2014 10:40:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>,
        linux-rpi-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1414457566-31802-1-git-send-email-matthias.klein@linux.com> <54504407.3090700@wwwdotorg.org> <5450AE6F.8010102@linux.com>
In-Reply-To: <5450AE6F.8010102@linux.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 03:07 AM, Matthias Klein wrote:
>
> Am 29.10.2014 um 02:33 schrieb Stephen Warren:
>> On 10/27/2014 06:52 PM, Matthias Klein wrote:
>>> The model B and B+ differ in the GPIO lines for ACT and PWR led.
>>> The PWR led on the B+ model is active low.
>> This new file is almost identical to bcm2835-rpi.dts. Perhaps we can use
>> some include files to share the common portions so they aren't
>> duplicated. Roughly:
>>
>> * Move all the common content from bcm2835-rpi.dts into bcm2835-rpi.dtsi.
>>
>> * Update bcm2835-rpi.dts to include bcm2835-rpi.dtsi to get all the
>> common parts, and add the few lines of differences.
>>
>> * Update this patch similarly.
>>
>> Does that make sense?
> Yes, I will work on such a patchset.
>
>>
>> A couple changes to this patch and the existing bcm2835-rpi.dts might
>> reduce the differences even further, leading to more common code in
>> bcm2835-rpi.dtsi:
>>
>> - Add the PWR LED to bcm2835-rpi-b.dts, if appropriate.
>> - Add the I2S pinmux settings for B+ too.
>>
>>> diff --git a/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
>>> b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
>> ...
>>> +&mmc {
>> That label doesn't exist; it should be &sdhci. Consequently:
>
> Sorry, I based my patch on the wrong tree. I used
> https://github.com/pietrushnic/rpi-dt-linux/tree/rpi-3.17.y which
> contains non upstream commits.
>
> Which tree should I use in general for work on the BCM2835? Is
> linux-next the right tree?

linux-next would usually work.

The most recent Linus kernel would also often be a good base, or perhaps 
any recent branch (of which there are none at present) in:

https://git.kernel.org/cgit/linux/kernel/git/swarren/linux-rpi.git/
(
which will hopefully soon move to:
https://git.kernel.org/cgit/linux/kernel/git/rpi/linux-rpi.git/
)

Which you pick depends on things like how many other patches touch the 
same files, and which branches/repos they were applied in, and what 
conflicts/dependencies exist.

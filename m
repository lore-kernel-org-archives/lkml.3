Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456Ab3HIGnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:43:39 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:41449 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030352Ab3HIGnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:43:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-L3XKMYMRjX8MX=i4ppNixZB=2FjO48_pxRnXvaco_DWg@mail.gmail.com>
References: <1375980335-19943-1-git-send-email-ricardo.ribalda@gmail.com>
 <1375980335-19943-2-git-send-email-ricardo.ribalda@gmail.com>
 <CAK5ve-+nnAGAnFNb6=QuekDMQwJ7w7h7k67dES0=wTN07n-9NA@mail.gmail.com>
 <alpine.DEB.2.01.1308090013440.21412@pmeerw.net> <CAK5ve-L3XKMYMRjX8MX=i4ppNixZB=2FjO48_pxRnXvaco_DWg@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 9 Aug 2013 08:43:16 +0200
Message-ID: <CAPybu_1G5yjQpxrQ7qZhnic22J59ajnPcd-Srgjxy0fcENos1A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] leds-pca9633: Add support for PCA9634
To: Bryan Wu <cooloney@gmail.com>
Cc: Peter Meerwald <p.meerwald@bct-electronic.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bryan

I understand your concerns, but I think that it is more practical to
keep the old names.

First of all there will be some defconfig that we will break with the
new names, the same will happen with the platform data. I know that we
don't have to support out of tree systems, but it wont hurt to make
their live easier.

The patch produced when we rename a file is as big as the file itself,
so it is more difficult to get good reviews, compared to a 10 lines
patch.

Unless the manufacturer makes a statement, there is no way to know if
there will be a pca96339 that will be a completely different chip, and
that will led to many errors.

Finally, there are many examples of files named as the first device
supported, even on the led infrastructure (ie. LEDS_DA9052)

All that said, I have added a new patch to the series that does the
renaming :), therefore we can review the addition 96334 separately
than the other improvements and if we decide to have a generic name we
will have it.

Thanks for your review!


On Fri, Aug 9, 2013 at 12:49 AM, Bryan Wu <cooloney@gmail.com> wrote:
> On Thu, Aug 8, 2013 at 3:36 PM, Peter Meerwald
> <p.meerwald@bct-electronic.com> wrote:
>> Hello,
>>
>>> > Add support for PCA9634 chip, which belongs to the same family as the
>>> > 9633 but with support for 8 outputs instead of 4.
>>
>>> Basically I like this method to add a new chip supporting. Please find
>>> my comments below.
>>
>> me too :)
>>
>>> What about just rename the whole file to leds-pca963x.c. And rename
>>> some pca9633 to pca963x in the driver.
>>
>> there are other, similar I2C LED driver chips which might be
>> handled with the current pca9633 driver, e.g. the pca9685 (which is
>> supported under pwm/ by the way)
>>
>> people have argued that the numbering scheme of chips is hard to
>> predict; hence, the driver name should be determined by the first
>> device supported to avoid subsequent renaming -- but I have no strong
>> feelings about this
>>
>
> Giving a more generic and meaningful name of this driver should be a
> easier for people to understand. So if pca9685 is coming, we can use
> leds-pca96xx.c and pca96xx for this pca96xx chip family, as long as
> they can share this driver code.
>
> Please take a look at Milo did in leds-lp55xx drivers.
>
> Thanks a lot,
> -Bryan



-- 
Ricardo Ribalda

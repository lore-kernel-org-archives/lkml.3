Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaLQSUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:20:24 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33639 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaLQSUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:20:22 -0500
MIME-Version: 1.0
In-Reply-To: <201412171854.00902@pali>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
	<1418155621-21644-4-git-send-email-pali.rohar@gmail.com>
	<201412101251.30610@pali>
	<201412171854.00902@pali>
Date: Wed, 17 Dec 2014 18:20:21 +0000
Message-ID: <CABz95_C1UzbRMgjDKcrdRzr2VGvAwmvWBRrP2116k3CQx+2sRg@mail.gmail.com>
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult,
 fan_max) from driver
From: Steven Honeyman <stevenhoneyman@gmail.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2014 at 17:54, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Wednesday 10 December 2014 12:51:30 Pali Rohár wrote:
>> On Tuesday 09 December 2014 21:07:01 Pali Rohár wrote:
>> > Now we have autodetection code for fan multiplier and
>> > maximal fan speed so we do not need to have those constants
>> > for each laptop in kernel driver code.
>> >
>> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> > ---
>> > !!!Please do not apply this patch until all affected
>> > machines will be tested!!!
>> >
>> > I tested autodetection code only on Dell Latitude E6440
>> > (where it worked). Other machines which needs to be tested:
>> >
>> > Dell Latitude D520
>> > Dell Latitude E6540
>> > Dell Precision WorkStation 490
>> > Dell Studio
>> > Dell XPS M140 (MXC051)
>> > ---
>>
>> Can somebody else with dell laptops test this patch series?
>
> Steven Honeyman, can you test this autodetection patch on your
> Latitude E6540?

Sure. You picked the best possible time of day to ask (seriously!)
Just applied patches 1,2,3 and so far seems exactly as before so it
looks OK to me.

While I was spamming "sensors" I did notice this (output trimmed for
neatness) but it is unusual my laptop fan is ever off so it might have
always done this and I would have never noticed:
Each line is about 0.5 - 1 second apart:

fan2:        3186 RPM
fan2:        3231 RPM
<temp is low enough, fan stops>
fan2:        10000 RPM
fan2:        9544 RPM
fan2:        10000 RPM
fan2:           0 RPM
(stays at 0 while fan is off)
<temp back up, fan starts>
fan2:        3236 RPM
fan2:        3597 RPM

Ever seen this before? I'd roll back and test again but this room and
laptop are too warm for the fan to stop completely now.


Thanks,
Steven

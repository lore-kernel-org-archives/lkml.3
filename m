Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab3HDGmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 02:42:53 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43949 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3HDGmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 02:42:51 -0400
MIME-Version: 1.0
In-Reply-To: <51FDABFD.3070601@gmail.com>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com>
	<3682340.ddGL4l7l22@vostro.rjw.lan>
	<51FCBBCC.6060307@gmail.com>
	<13505759.IqzsRNCUnN@vostro.rjw.lan>
	<51FDABFD.3070601@gmail.com>
Date: Sun, 4 Aug 2013 01:42:49 -0500
Message-ID: <CAMP44s0+VKH_vTRiXvhKz8gGUwAa+_Hgf_dN3UddYE1Z7DLPAA@mail.gmail.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 3, 2013 at 8:18 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
> On 08/03/2013 07:34 PM, Rafael J. Wysocki wrote:
>> On Saturday, August 03, 2013 04:14:04 PM Aaron Lu wrote:
>>> On 08/03/2013 07:47 AM, Rafael J. Wysocki wrote:
>>>> On Friday, August 02, 2013 02:37:09 PM Felipe Contreras wrote:
>>>>> If the _BCL package is descending, the first level (br->levels[2]) will
>>>>> be 0, and if the number of levels matches the number of steps, we might
>>>>> confuse a returned level to mean the index.
>>>>>
>>>>> For example:
>>>>>
>>>>>   current_level = max_level = 100
>>>>>   test_level = 0
>>>>>   returned level = 100
>>>>>
>>>>> In this case 100 means the level, not the index, and _BCM failed. But if
>>>>> the _BCL package is descending, the index of level 0 is also 100, so we
>>>>> assume _BQC is indexed, when it's not.
>>>>>
>>>>> This causes all _BQC calls to return bogus values causing weird behavior
>>>>> from the user's perspective. For example: xbacklight -set 10; xbacklight
>>>>> -set 20; would flash to 90% and then slowly down to the desired level
>>>>> (20).
>>>>>
>>>>> The solution is simple; test anything other than the first level (e.g.
>>>>> 1).
>>>>>
>>>>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>>>>
>>>> Looks reasonable.
>>>>
>>>> Aaron, what do you think?
>>>
>>> Yes, the patch is correct, but I still prefer my own version :-)
>>> https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9
>>>
>>> In case you want to take mine and mine needs refresh, please let me know
>>> and I can do the re-base, thanks.
>>
>> Well, I prefer simpler, unless there's a good reason to use more complicated.
>>
>> Why exactly do you think your version is better?
>
> As explained here:
> https://lkml.org/lkml/2013/8/2/81
> https://lkml.org/lkml/2013/8/2/112
>
> And for the demo broken _BQC, mine patch will disable _BQC while still
> make the backlight work, and this patch here is testing the max
> brightness level and may fail.

Yes, but that problem can *only* happen in such a simplified _BCL,
which is very very unlikely. Still, it would make sense to fix the
code for that case.

However, we can fix the problem first for the real known cases with my
simple one-liner patch that can even be merged for v3.11, and *later*
fix the issue for the synthetic unlikely case.

Personally I think there are better ways to fix the code for the
synthetic case than what you patch does, which will also make _BQC
work. That can be discussed later though, the one-liner is simple, and
it works.

-- 
Felipe Contreras

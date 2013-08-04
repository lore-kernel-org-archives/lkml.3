Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3HDBSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 21:18:13 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49961 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab3HDBSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 21:18:12 -0400
Message-ID: <51FDABFD.3070601@gmail.com>
Date: Sun, 04 Aug 2013 09:18:53 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com> <3682340.ddGL4l7l22@vostro.rjw.lan> <51FCBBCC.6060307@gmail.com> <13505759.IqzsRNCUnN@vostro.rjw.lan>
In-Reply-To: <13505759.IqzsRNCUnN@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 07:34 PM, Rafael J. Wysocki wrote:
> On Saturday, August 03, 2013 04:14:04 PM Aaron Lu wrote:
>> On 08/03/2013 07:47 AM, Rafael J. Wysocki wrote:
>>> On Friday, August 02, 2013 02:37:09 PM Felipe Contreras wrote:
>>>> If the _BCL package is descending, the first level (br->levels[2]) will
>>>> be 0, and if the number of levels matches the number of steps, we might
>>>> confuse a returned level to mean the index.
>>>>
>>>> For example:
>>>>
>>>>   current_level = max_level = 100
>>>>   test_level = 0
>>>>   returned level = 100
>>>>
>>>> In this case 100 means the level, not the index, and _BCM failed. But if
>>>> the _BCL package is descending, the index of level 0 is also 100, so we
>>>> assume _BQC is indexed, when it's not.
>>>>
>>>> This causes all _BQC calls to return bogus values causing weird behavior
>>>> from the user's perspective. For example: xbacklight -set 10; xbacklight
>>>> -set 20; would flash to 90% and then slowly down to the desired level
>>>> (20).
>>>>
>>>> The solution is simple; test anything other than the first level (e.g.
>>>> 1).
>>>>
>>>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>>>
>>> Looks reasonable.
>>>
>>> Aaron, what do you think?
>>
>> Yes, the patch is correct, but I still prefer my own version :-)
>> https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9
>>
>> In case you want to take mine and mine needs refresh, please let me know
>> and I can do the re-base, thanks.
> 
> Well, I prefer simpler, unless there's a good reason to use more complicated.
> 
> Why exactly do you think your version is better?

As explained here:
https://lkml.org/lkml/2013/8/2/81
https://lkml.org/lkml/2013/8/2/112

And for the demo broken _BQC, mine patch will disable _BQC while still
make the backlight work, and this patch here is testing the max
brightness level and may fail.

-Aaron

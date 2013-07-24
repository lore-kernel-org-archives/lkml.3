Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3GXK5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:57:04 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46716 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3GXK5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:57:02 -0400
MIME-Version: 1.0
In-Reply-To: <51EF773F.40903@gmail.com>
References: <CADDKRnBRyJZCoy3G53b6tY7J21XZp5bGn7nJi87WUgEGhSuT_w@mail.gmail.com>
	<51EF773F.40903@gmail.com>
Date: Wed, 24 Jul 2013 12:57:01 +0200
Message-ID: <CADDKRnDNoqYCzS_gKHhKvymEgtRVoptmeYDHf3ujSAYe5KpVGw@mail.gmail.com>
Subject: Re: [v3.11-rc2] regression: brightness always on maximum.
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rafael.j.wysocki@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/24 Aaron Lu <aaron.lwe@gmail.com>:
> On 07/23/2013 03:52 PM, Jörg Otte wrote:
>> The brightness of my laptop is always on maximum and can't be scaled
>> down.
>> Brightness control via function keys was always working on this
>> laptop, so this is a regression in v3.11-rc2.
>
> Please list /sys/class/backlight.

# cd /sys/class
# find backlight -name "*"
backlight
backlight/intel_backlight
# cd backlight/intel_backlight
# ls
actual_brightness  bl_power  brightness  device  max_brightness  power
 subsystem  type  uevent
# cat actual_brightness
0
# cat max_brightness
4882

actual_brightness is 0, but brightness is on maximum!

>
> If there is a intel_backlight, please try to adjust brightness level
> through brightness file like this:
> # echo XXX > /sys/class/backlight/intel_backlight/brightness
> Does it work?

no, it doesn't have any visible effect.


Thanks, Jörg

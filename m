Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaAIRv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:51:56 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35167 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbaAIRvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:51:47 -0500
MIME-Version: 1.0
In-Reply-To: <201401091524.53417@pali>
References: <20140107204233.GA22413@amd.pavel.ucw.cz> <CAK5ve-Kk9BuH=56F98aZOgPS+w-=8iF0HtpOYWNjRN8am2Zqjg@mail.gmail.com>
 <201401091524.53417@pali>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 9 Jan 2014 09:51:25 -0800
Message-ID: <CAK5ve-K3oz+cY=g025gnjYzCTmUm2AVV8Tcc9Zg+Sb2jBu1fOw@mail.gmail.com>
Subject: Re: Broken locking in leds-lp5523.c
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, milo kim <milo.kim@ti.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 6:24 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Wednesday 08 January 2014 01:32:15 Bryan Wu wrote:
>> On Tue, Jan 7, 2014 at 12:42 PM, Pavel Machek <pavel@ucw.cz>
> wrote:
>> > Hi!
>> >
>> > There's some locking weirdness, and few missing comments in
>> > lp5523 driver.
>> >
>> > Now, this is untested patch from my reverse-engineering. I
>> > hope I understood things right...
>> >
>> > In particular, there's unbalanced unlock in
>> > lp5523_update_program_memory, and
>> > lp5523_update_program_memory needs to be protected by the
>> > lock.
>> >
>> > Comments? Does someone maintain this?
>>
>> Actually the locking issue was fixed in my for-next branch,
>> http://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-led
>> s.git/commit/?h=for-next&id=0d70bdb957cde2c25a4b3e4c93d0d33403
>> 795be9
>>
>> Thanks,
>> -Bryan
>>
>
> Now, with linus tree lp5523 driver does not work without above
> commit on Nokia N900 device. I think that commit should go to
> 3.13 and stable... What do you think?
>

OK, can you just apply this fix on Linus tree and verify it on N900?
If only this fix will make N900 LED work, I will send out to Linus as
a critical fix for 3.13 as well as stable tree. Because there 2 more
patches for LED comes from Milo also fixed something and this patch
probably depends on them.

Please help to verify.

Thanks,
-Bryan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3HEW4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:56:05 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:37593 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab3HEW4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <201308050931.26353@pali>
References: <201308041146.03970@pali> <A874F61F95741C4A9BA573A70FE3998F82E85CC4@DQHE06.ent.ti.com>
 <201308050931.26353@pali>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 5 Aug 2013 15:55:40 -0700
Message-ID: <CAK5ve-J-WKgvojOtfQTRmfFrdZxR=oL7AHoRuECUurhVL3FHmQ@mail.gmail.com>
Subject: Re: leds-lp5523: Broken commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Cc: "Kim, Milo" <Milo.Kim@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 12:31 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Monday 05 August 2013 09:26:46 Kim, Milo wrote:
>> > Hello,
>> >
>> > git commit "leds-lp5523: use generic firmware interface"
>> > db6eaf8388a413a5ee1b4547ce78506b9c6456b0 introduced in
>> > kernel 3.10 changed user space API for modifing lp5523 led
>> > patterns via /sys.
>> >
>> > Before this commit there were sysfs attributes engineX_mode,
>> > engineX_load and engineX_leds (for every engine X).
>> >
>> > Now (after commit) there are sysfs attributes:
>> > select_engine, loading and data (see:
>> > 10c06d178df11b0b2b746321a80ea14241997127 for description).
>> > Old sysfs attributes were removed.
>> >
>> > So commit db6eaf8388a413a5ee1b4547ce78506b9c6456b0 totally
>> > broke all existing userspace applications which use lp5523
>> > leds.
>> >
>> > This also broke application MCE which is used on Nokia N900
>> > phone for changing LED patterns in lp5523 led.
>>
>> First of all, I'm really sorry for this conflict.
>>
>> > I think that kernel api which is used by userspace
>> > applications (like attributes in /sys) should not be
>> > changed in way that totally broke existing applications.
>> >
>> > Can you fix this api problem? (maybe adding old sysfs
>> > attributes which would call new api function...)
>>
>> I'll recover old sysfs attributes and implement them by using
>> new functions. Additionally, I'll do same works in LP5521
>> driver also.
>>
>> Best Regards,
>> Milo
>
> Hi, thank you very much!
>

Also my bad, I should noticed that and keep those old APIs at that moment.
Thanks for reporting this. I think Milo is going to fix it and I
probably pull this fix into 3.11 cycle instead of next merge window.

-Bryan

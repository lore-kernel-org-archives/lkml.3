Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3HBUDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:03:08 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52172 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3HBUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:03:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s16-_KA+3JPSzD1CrzcNCuCk4xjOvU6E=gVRxkKiAGr0Q@mail.gmail.com>
References: <20130731162252.GC4724@pd.tnic>
	<CAPBO7TaPxa_13FBDE5Z=Aoa+ePPfLRH0+oWSQyEmO00xSfGqYg@mail.gmail.com>
	<CAMP44s1WMMXcGfF6Ta0CFthY3-7tkpqXEPx1iZhVU-XpS6KUWw@mail.gmail.com>
	<1544218.2BR9ul04Pj@vostro.rjw.lan>
	<CAMP44s16-_KA+3JPSzD1CrzcNCuCk4xjOvU6E=gVRxkKiAGr0Q@mail.gmail.com>
Date: Fri, 2 Aug 2013 22:03:04 +0200
Message-ID: <CAPBO7TZT3hX67aX-2aG5f2mcVqOyka2xbTPvMWvHzTG-x+UBLA@mail.gmail.com>
Subject: Re: i915 backlight
From: Josep Lladonosa <jlladono@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@alien8.de>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With this setup, something has happened: in xorg, when screen goes to
screensaver and after, enters into Standby mode, when I press a key,
it keeps black and, to recover screen, I have to adjust brightness
manually (by increasing), as if it didn't remember previous value to
standby mode.

This was something that before didn't happen.

Josep

On 2 August 2013 20:58, Felipe Contreras <felipe.contreras@gmail.com> wrote:
> On Fri, Aug 2, 2013 at 9:03 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Friday, August 02, 2013 01:48:37 AM Felipe Contreras wrote:
>>> On Fri, Aug 2, 2013 at 1:25 AM, Josep Lladonosa <jlladono@gmail.com> wrote:
>>> > Hello,
>>> >
>>> > I am using a Lenovo Edge E530 and, with kernel 3.11.0-rc3, I had to
>>> > change to this parameter to the kernel boot:
>>> >
>>> >
>>> > GRUB_CMDLINE_LINUX="acpi_osi=\"!Windows 2012\""
>>>
>>> I think it's pretty obvious that for the time being we need to
>>> blacklist a ton of machines so they boot without this OSI. In fact, in
>>> might make sense to simply remove the OSI completely for all machines
>>> (for now).
>>
>> That would have made sense 6 months ago, but not today.
>
> Today, like 6 months ago these machines remain broken, and it will be
> the same tomorrow, presumably on v3.11, and at least v3.12 as well.
>
>> The reason is that you don't really know what's affected by that and I'm
>> pretty sure it's not only backlight.
>
> I haven't heard a single comment that says acpi_osi="!Windows 2012"
> breaks other things. OTOH everybody is saying it fixes the backlight
> problem (if indeed it's the same problem).
>
> Are you claiming that those users are wrong?
>
>> So no, we won't do that.
>
> Yeah, because that would fix the backlight problems, not tomorrow, or
> several months from now, *today*. Geez, who would want that?
>
> Here is the patch to fix the problem, *today*.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=60682
>
> This is what we should do:
>
> 1) Improve that blacklist list
> 2) Fix the Intel driver issues
> 3) Enable your patch that uses the Intel driver instead
> 4) Remove that patch
>
> Anything else is not be good for the users.
>
> --
> Felipe Contreras



-- 
--
Salutacions...Josep
--

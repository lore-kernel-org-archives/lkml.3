Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3G3DoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:44:22 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:33838 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3G3DoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <51F72EF3.8080706@gmail.com>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
	<51F72EF3.8080706@gmail.com>
Date: Mon, 29 Jul 2013 22:44:19 -0500
Message-ID: <CAMP44s2Wysia0qHGcnGbBBgrzEvsys_0A1X=t8WT52XwojG7Og@mail.gmail.com>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:11 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
> On 07/30/2013 03:20 AM, Felipe Contreras wrote:
>> Since v3.7 the acpi backlight driver doesn't work at all on this machine
>> because presumably the ACPI code contains stub code when Windows 8 OSI is
>> reported.
>>
>> The commit ea45ea7 (in v3.11-rc2) tried to fix this problem by using the intel
>> backlight driver, however, on this machine it turns the backlight completely
>> off when it reaches level 0%, after which the user might have a lot trouble
>> trying to bring it back.
>
> What do you mean by a lot of trouble? If you press hotkey to increase
> backlight brightness level, does it work?

I guess so, *if* there is indeed a user-space power manager handling
that, *and* the keyboard has such keys, *or* the user has set custom
hotkeys.

> If so, the screen should not
> be black any more, it's not that user has to blindly enter some command
> to get out of the black screen.
>
> And I'm not sure if this is a bug of intel_backlight(setting a low level
> makes the screen almost off), I see different models with different
> vendors having this behavior.

I mean, the screen is completely off, I cannot see absolutely
anything. I don't see this behavior with the ACPI backlight driver,
nor do I see that in Windows 7.

> If this is deemed a bug, then I'm afraid
> intel_backlight interface is useless for a lot of systems...perhaps we
> can only say, intel_backlight's interpretation of low levels are
> different with ACPI video's, and that's probably why its type is named
> as raw :-)

Well, a bug is defined as unexpected behavior -- as a user, if I'm
changing the brightness of the screen, I certainly don't expect the
screen to turn off, and I think that's the expectation from most
people. It's the first time I see something like that.

-- 
Felipe Contreras

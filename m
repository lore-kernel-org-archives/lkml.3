Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3LSRDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:03:13 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38595 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3LSRDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131219163606.GA29243@gmail.com>
References: <1387374611-12493-1-git-send-email-dh.herrmann@gmail.com>
	<1387448038-8260-1-git-send-email-dh.herrmann@gmail.com>
	<20131219163606.GA29243@gmail.com>
Date: Thu, 19 Dec 2013 18:03:08 +0100
Message-ID: <CANq1E4Ss30G72t3R1iza9vOO7ESYQynjS74mB+nJ-zT2zAvyzQ@mail.gmail.com>
Subject: Re: [PATCH v3] x86: sysfb: remove sysfb when probing real hw
From: David Herrmann <dh.herrmann@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Dec 19, 2013 at 5:36 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * David Herrmann <dh.herrmann@gmail.com> wrote:
>
>> --- a/drivers/video/fbmem.c
>> +++ b/drivers/video/fbmem.c
>> @@ -35,6 +35,9 @@
>>
>>  #include <asm/fb.h>
>>
>> +#if IS_ENABLED(CONFIG_X86)
>> +#include <asm/sysfb.h>
>> +#endif
>
> I think this can be written as:
>
> #ifdef CONFIG_X86
> # include <asm/sysfb.h>
> #endif
>
> also ... the dependency on a large, unrelated option like CONFIG_X86
> looks pretty ugly here - is there no other, more specific CONFIG_
> option that can be used here - such as CONFIG_FB_SIMPLE or
> CONFIG_X86_SYSFB?
>
>> +#if IS_ENABLED(CONFIG_X86)
>> +     sysfb_unregister(apert, primary);
>> +#endif
>
> Ditto.

CONFIG_X86 is probably never 'm'.. will fix that.
It was CONFIG_X86_SYSFB before and that works, too, but the broader
X86 seemed more appropriate as sysfb is available on all x86.

Note that I have patches here locally which move
sysfb_register/unregister to drivers/video/sysfb.c and add
include/linux/sysfb.h with dummies if CONFIG_SYSFB is not selected to
avoid the #ifdef. This will allow other architectures to do
gfx-hand-over, too. They seem too big for stable, though. That's why I
split them up and added it to x86/kernel/sysfb.c first.

Thanks
David

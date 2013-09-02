Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3IBVqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:46:24 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41841 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976Ab3IBVqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:46:22 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <CAMuHMdU1Dt2KOJny78d2DdprHwF5cOQEMGDm7rVDMRyL1jTAsA@mail.gmail.com>
References: <1378147630-12471-1-git-send-email-teg@jklm.no>
 <CAFLxGvy+oBg-Qbd_8wL-86ODpB9fand2aVcyVcRRLarRe40wSw@mail.gmail.com> <CAMuHMdU1Dt2KOJny78d2DdprHwF5cOQEMGDm7rVDMRyL1jTAsA@mail.gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 2 Sep 2013 23:46:00 +0200
Message-ID: <CAG-2HqX62iR_2fyFGAdTavL43EVLQ=cAoEArfKCkTVmxaEWQuw@mail.gmail.com>
Subject: Re: [PATCH] input: allow SERIO=m even without EXPERT=y
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 11:30 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Sep 2, 2013 at 11:01 PM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Mon, Sep 2, 2013 at 8:47 PM, Tom Gundersen <teg@jklm.no> wrote:
>>> There is plenty of consumer hardware (e.g., mac books) that does not use
>>> AT keyboards or PS/2 mice. It therefore makes sense for distro kernels
>>> to build the related drivers as modules to avoid loading them on hardware
>>> that does not need them. As such, these options should no longer be protected
>>> by EXPERT.
>>>
>>> Moreover, building these drivers as modules gets rid of the following ugly
>>> error during boot:
>>>
>>> [    2.337745] i8042: PNP: No PS/2 controller found. Probing ports directly.
>>> [    3.439537] i8042: No controller found
>>>
>>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>> ---
>>>  drivers/input/keyboard/Kconfig | 4 ++--
>>>  drivers/input/serio/Kconfig    | 6 +++---
>>>  2 files changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
>>> index 269d4c3..2d31cec 100644
>>> --- a/drivers/input/keyboard/Kconfig
>>> +++ b/drivers/input/keyboard/Kconfig
>>> @@ -2,7 +2,7 @@
>>>  # Input core configuration
>>>  #
>>>  menuconfig INPUT_KEYBOARD
>>> -       bool "Keyboards" if EXPERT || !X86
>>> +       bool "Keyboards"
>>
>> Maybe this a stupid question, but why are you dropping the "!X86" too?
>
> Because the "if EXPERT" only mattered for X86.
>
> Apply De Morgan and it read like "do not ask the question if !EXPERT && X86".

Precisely.

-t

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3AVKDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:03:07 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46410 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3AVKDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:03:04 -0500
MIME-Version: 1.0
In-Reply-To: <201301221817.IDD95831.HVOOFMFJOLFSQt@I-love.SAKURA.ne.jp>
References: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
	<CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
	<201301221817.IDD95831.HVOOFMFJOLFSQt@I-love.SAKURA.ne.jp>
Date: Tue, 22 Jan 2013 11:03:04 +0100
Message-ID: <CACRpkdYRM9MDt92juV+x9w9BUnHpCSd2KCkZ5F7zwPfhn939ZQ@mail.gmail.com>
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Linus Walleij <linus.walleij@linaro.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:17 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:

>> 1.  Get hold of the patch fixing the boot regression:
>>     git format-patch
>> f5565295892eb93c3191aa241405fe8b685542d6^..f5565295892eb93c3191aa241405fe8b685542d6
>
> Thanks, but sorry, I couldn't understand how this command line works.
>
> Which one ("blank console bug" or "IRQ registration failure bug") does
> "the boot regression" refer?

They are likely one and the same bug? The only regression on
the versatile I have caused came from commit
f5565295892eb93c3191aa241405fe8b685542d6.

> Your command line generated only one patch but you say "iterate".

I mean you should iterate the process, not the patch generation.

>   $ git format-patch f5565295^..f5565295
>   0001-ARM-7610-1-versatile-bump-IRQ-numbers.patch
>
> If I use 5c49985c^..5c49985c (the patch which the blank console bug was fixed),
> it generated 8 patches.

This is because you have made git format-patch in a merge commit
which contains several patches.

You can probably actually apply all of them at each step like
that if  you prefer: patch -p1 < *.patch

> Since the IRQ registration failure bug message contains IRQ number "27",
> I suspect f5565295 "ARM: 7610/1: versatile: bump IRQ numbers"

Me too :-) Atleast Grant told me that that one patch fixed the
boot regression.

And that is why I mentioned that patch specifically above,
I think it's the only one you need.

> and 5ced33bc06 "ARM: 7611/1: VIC: fix bug in VIC irqdomain code"

I don't think you need this patch.

> but how can I test them?

Apply/compile/boot?

Sorry I don't quite get the question?

>> 2. At each iterative step using git bisect:
>>    patch -p1 < 0001-ARM-7610-1-versatile-bump-IRQ-numbers.patch
>>
>> 3. Boot/trial-and-horror
>>
>> 4. git reset --hard HEAD
>>    To nullify the effects of the patch.
>>
>> 5. git bisect [good|bad]
>>
> Excuse me, what range do I need to pass to "git bisect start" command line?

Same as you mentioned in your first mail I suppose?

>> 6. Iterate from (2) until you find the bug.

When you cannot proceed because you need a patch unrelated to the
problem you want to solve, you apply that patch on top of the
bisection HEAD with patch -p1 < foo.patch, test, reset HEAD,
git bisect <result> etc....

I'm sorry if this is a bit complicated but bisection down several
regressions is one of the more advanced forms of regression
bug hunt... You're quite cool if you can handle it :-)

Yours,
Linus Walleij

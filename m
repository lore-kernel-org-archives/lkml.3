Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3IROxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:53:53 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45366 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3IROxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:53:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130918142203.GD3748@amd.pavel.ucw.cz>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309172128.42514@pali> <20130918014942.GD19817@radagast>
 <201309181020.15245@pali> <CAAwP0s1Ou7Nrq7GhnHX71TFCrTFg=nqUh+GsAJhN8DjZGsF4QQ@mail.gmail.com>
 <20130918133025.GB2953@amd.pavel.ucw.cz> <CAAwP0s0nGthkm9Bp1ug23Rtz6-sbR60FFTSfd-Cj9wKMU0RBEA@mail.gmail.com>
 <20130918142203.GD3748@amd.pavel.ucw.cz>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Wed, 18 Sep 2013 16:53:28 +0200
Message-ID: <CAAwP0s1Xch+pGR7tEX3p9VN2xBN_SeW1uUB1YLiTpEO6puNrew@mail.gmail.com>
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when
 status is changed
To: Pavel Machek <pavel@ucw.cz>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, freemangordon@abv.bg,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 4:22 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> >> > So will you do that? Or it is needed to resend this one line
>> >> >> > hunk again in new email again?
>> >> >>
>> >> >> new patch, new email
>> >> >
>> >> > Guys, WHY ARE YOU SO STUPID AND ARROGANT?
>> >> >
>> >> > Sorry but, need to copy full isolated patch/hunk from one mail to
>> >> > another is hassling. So what you want from me? Do all those non
>> >> > sense working only because yesterday you had bad day? Or what?
> ...
>> > Actually, there is need to be rude, because Felipe fails to act as
>> > maintainer. Instead of fixing bugs in his code, he bounces bugfix
>> > patches, points people to random READMEs and wastes everyones time.
>>
>> I don't know what are you talking about (if that happened in another
>> thread then I need more context). Felipe is not bouncing any bugfix
>
> Take a look here:
>
> https://lkml.org/lkml/2013/9/17/286
>
> I clearly state that patch can not be tested as required for "proper"
> submission, but offer patch anyway. I get irrelevant boilerplate on
> patch format.
>

Felipe didn't complain about you not being to be able to test the
patch (most of the times compile tested if enough) what he said was:

"Seriously though, read that file, you're commit log has garbage in it
which shouldn't go to git history".

which is totally true, if you want to comment things that don't have
to go to the backlog you can't comment between the --- after your
s-o-b and before the first diff. That's were you should puts comments
like "Hi! or Here's suggested patch. I don't have the hardware, so it
is completely untested."

>> but just asked to split the patch in two since the patch was solving
>> two separate issues so is way better to have it in two separate
>> patches for the reasons I explained before.
>>
>> So, as far as I can tell Felipe did exactly what I would expect from a
>> maintainer. He took the time to review the patches sent to him and
>
> I'd expect maintainer to, well, maintain code. It means actually
> fixing bugs in his code, when he's pointed at them.
>
>> gave feedback. If the sender doesn't want to take his feedback into
>> account and prefer to send pretty insulting emails instead that is his
>> choice but I would say that is this not the greatest approach to get
>> your code merged (to say the least).
>
> Clearly not. But Pali found bug in code Felipe should
> maintain. Instead of "thank you for bug report, I applied this one
> line of your code to fix it", Pali got "new patch, new email" for his
> efforts. That is how you train dogs, not how you should treat kernel
> contributors.
>

No, you misunderstood the role of the maintainers. Maintainers should
be custodian of a part of the kernel but not responsible for every
single line of code on their sub-systems. If a piece of code is buggy
then the people using and that take care of that should be fixing and
maintainers should review and suggest improvements to the patches. As
long as a piece of code keep compiling then it is harmless even if is
buggy and nobody cares about it. If it is so broken that it doesn't
even compile then the maintainer can decide to just drop it since no
one else seems to care about it.

If someone finds a bug on a piece of code is because that people care
about that functionality. Maintainers are really busy people and can
jump and fix any random bug that someone finds on a piece of code just
because it is the subsystem they maintainer neither they have to
blindly merge any crappy patch just because they don't have time (or
interest) in fixing a reported bug on a piece of code.

> Now, it is possible that Felipe just has problems with english, as he
> called me piece of wood in https://lkml.org/lkml/2013/9/17/476 , but
> he appears more arogant than usual over email.
>

Clearly he meant "your commit log has garbage" instead of you're, that's a typo.

>                                                                 Pavel

But neither Felipe needs someone to defend him nor I have time to keep
arguing with you.

Have nice day!
Javier

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3IZL5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:57:08 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1663 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756642Ab3IZL5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:57:05 -0400
Message-ID: <52442108.1020304@nod.at>
Date: Thu, 26 Sep 2013 13:56:56 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: linux-arch@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        geert@linux-m68k.org, ralf@linux-mips.org, lethal@linux-sh.org,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/8] um: Do not use SUBARCH
References: <1377073172-3662-1-git-send-email-richard@nod.at> <1377073172-3662-3-git-send-email-richard@nod.at> <CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com> <52441025.9030308@nod.at> <CALkWK0k5neR50h+AWEF5AgnpbgWMitZUnbv_caVzt6HiUA6mXg@mail.gmail.com> <52441407.9010603@nod.at> <CALkWK0=FG4COEjv5+mu1JRiiFQ2k6vop1mhFPmAT4bjtYeK6nA@mail.gmail.com>
In-Reply-To: <CALkWK0=FG4COEjv5+mu1JRiiFQ2k6vop1mhFPmAT4bjtYeK6nA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 13:43, schrieb Ramkumar Ramachandra:
> Richard Weinberger wrote:
>>> Auto-detection of SUBARCH, which can be done with a simple call to
>>> uname -m (the 90% case). The second patch I submitted prevented
>>> spawning xterms unnecessarily, which we discussed was a good move.
>>
>> Covering only 90% of all cases is not enough.
>> We must not break existing setups.
>> That's also why my "Get rid of SUBARCH" series is not upstream.
> 
> Mine covers 100% of the cases. My series is about auto-detection of
> SUBARCH, not its removal: you can still set a SUBARCH from the
> command-line; existing setups don't break.

I told you already that "make defconfig ARCH=um SUBARCH=x86" will spuriously
create a x86_64 config on x86_64.
This breaks existing setups.

>> Your second patch changed CONFIG_CON_CHAN to pts, which is ok but not
>> a major issue.
> 
> "Major" or "minor" is purely your classification: don't impose your
> value judgement on reasonable patches. I am the user, and I demand a
> pleasant build process and ui. Moreover, how do you expect more
> contributions to come in until existing patches make it to upstream?
> 
>> The xterms are also not spawning unnecessarily they spawn upon a tty device is opened.
>> With your patch UML create another pts. Thus, the spawning is hidden...
> 
> It connects to an existing host pts device instead of spawning a new
> xterm and connecting to the console io on that. Why is that not
> desirable?
> 
>> I did not push it upstream because it depended on your first one and as I said, it's not critical.
>> This does not mean that I moved it to /dev/null.
> 
> ... and you still haven't told me what's wrong with my first patch.
> 
>> Again, the plan is to get rid of SUBARCH at all.
> 
> You've been harping about this plan for the last N months, and nothing
> has happened so far. It's time to stop planning, and accept good work.

I sent the series on Aug 21st.
Do the maths, it's not N months...

>>>> make defconfig ARCH=um SUBARCH=x86 (or SUBARCH=i386) will create a defconfig for 32bit.
>>>> make defconfig ARCH=um SUBARCH=x86_64 one for 64bit.
>>>
>>> Yes, that's how I prepared the patch in the first place.
>>
>> So, nothing is broken.
> 
> So the user is Ugly and Stupid for expecting:
> 
>   $ "
>   $ make -j 8 ARCH=um
> 
> to work? Stop denying problems, no matter how "major" or "minor" they are.

"make defconfig ARCH=um" creates a defconfig for x86 as it always did.
If you want to run a x86_64 bit user space, create a x86_64 defconfig.

>> If you want "make defconfig ARCH=um" creating a defconfig for the correct arch you need
>> more than your first patch.
> 
> No, you don't. Try it for yourself and see. Set a SUBARCH if you like,
> and it'll still work fine.
> 
>> Again, "Get rid of SUBARCH" series has the same goal.
> 
> For the last time, getting rid of SUBARCH is Wrong and Undesirable.

That's your opinion.

> -- 8< --
> Here's a transcript spoonfeeding you the impact of my first patch:
> 
>   $ make defconfig ARCH=um SUBARCH=i386
>   *** Default configuration is based on 'i386_defconfig'
>   #
>   # configuration written to .config
>   #
>   $ make defconfig ARCH=um SUBARCH=x86_64
>   *** Default configuration is based on 'x86_64_defconfig'
>   #
>   # configuration written to .config
>   #
>   $ make defconfig ARCH=um
>   *** Default configuration is based on 'x86_64_defconfig'
>   #
>   # configuration written to .config
>   #
> 
> In the last case, notice how defconfig automatically picks up
> x86_64_defconfig correctly: if I were on an i386 machine, it would
> have picked up i386_defconfig like in the first case. Without my
> patch, the last case would have incorrectly picked up an i386
> defconfig, which is Stupid and Wrong.

You missed SUBARCH=x86.

That said, if you cover all cases I'll happily merge that.
And honestly, your patches are minor stuff, they don't even touch C source files.
Acting up like you do just because of some default values is crazy.
We have more serious problems so solve.

Thanks,
//richard

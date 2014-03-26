Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbaCZVyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:54:13 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:64203 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbaCZVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:54:12 -0400
MIME-Version: 1.0
X-Originating-IP: [12.232.193.53]
In-Reply-To: <1395868919.5365.6.camel@pippen.local.home>
References: <1395839857.7667.9.camel@pippen.local.home>
	<1395857987.10059.23.camel@empanada>
	<1395868919.5365.6.camel@pippen.local.home>
Date: Wed, 26 Mar 2014 14:54:11 -0700
Message-ID: <CAOesGMiLOcC2KR4b9Jq=hJT=8NKK95itWx0BsX7NGsmBYYLbSw@mail.gmail.com>
Subject: Re: [GIT PULL] tracing: Fix traceon trigger condition to actually
 turn tracing on
From: Olof Johansson <olof@lixom.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 2:21 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Bah, I forgot to Cc LKML on my pull request. Doing this from a
> conference with very poor internet access from a laptop that I don't
> usually develop on, means I might make mistakes.
>
> On Wed, 2014-03-26 at 13:19 -0500, Tom Zanussi wrote:
>> On Wed, 2014-03-26 at 09:17 -0400, Steven Rostedt wrote:
>> > Linus,
>> >
>> > While on my flight to Linux Collaboration Summit, I was working on
>> > my slides for the event trigger tutorial. I booted a 3.14-rc7 kernel
>> > to perform what I wanted to teach and cut and paste it into my slides.
>> > When I tried the traceon event trigger with a condition attached to it
>> > (turns tracing on only if a field of the trigger event matches a condition
>> > set by the user), nothing happened. Tracing would not turn on. I stopped
>> > working on my presentation in order to find what was wrong.
>> >
>>
>> Hi Steve,
>>
>> Sorry you had to stop working on your presentation to dig into this -
>> thanks for doing that though - it looks correct and fixes the problem
>> here for me, so you can add my Tested-by:
>>
>> Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>
>
> Linus already pulled it. But Olof came to me at lunch to tell me my
> patch broke his PA Semi PPC box.
>
> Olof, as you well know, I also own one of those beasts, and I just
> booted the kernel with that patch and all works fine. Perhaps its a
> config issue? Can you send me your config.


I think it's a side effect, and something else is going on. If I build
an boot a ppc64_defconfig on the box (I mistakenly told you that it
was pasemi_defconfig), it hangs early during boot during PCI init,
halfway through printing a line of stack usage warning.

However, it seems fickle. If I disable the hung task detector it seems
to go away, for example. So, I think something else is going on and it
just happened to align the stars for it to happen.

I'll keep trying to change variables enough to see what's going on. I
really wish I still had JTAG access on this box, but all those tools
are since long gone and forgotten. The conference wifi makes it harder
to work on this too, as I'm sure you've noticed...

Don't let this hold up anything at this time, unless someone else complains.


-Olof

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3KJQYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 11:24:38 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41646 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3KJQYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 11:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvx-G8VkBvbdLkYSJee4oAU+4PdHzwszhaTaTMwGJAHkRA@mail.gmail.com>
References: <CALeOzZ_K0o_h4gJ4w-twL5=-0QjC1XWb=m948wXWwjndr4q_Kw@mail.gmail.com>
	<CAFLxGvx-G8VkBvbdLkYSJee4oAU+4PdHzwszhaTaTMwGJAHkRA@mail.gmail.com>
Date: Sun, 10 Nov 2013 17:24:35 +0100
Message-ID: <CALeOzZ-NQyOdxhd3e_c70i0HVMnxS=kcNLTVz8t7UCK9dqUMeg@mail.gmail.com>
Subject: Re: Partially Privileged Applications
From: Shahbaz Youssefi <shabbyx@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if I understood you (or you understood me). We don't throw
away anything. Only difference would be instead of generating a trap
to call a function in the kernel, we can just call it and have the
hardware take care of privileges. The "trap way" is the one that
actually seems hacky! A hack proposed to fix the brain-dead processors
of twenty years ago.

As a bonus you would also have more control over what parts of a
driver actually get run in privileged mode.

Care to explain why you would call this a step backwards?

On Sun, Nov 10, 2013 at 5:18 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Sun, Nov 10, 2013 at 4:03 PM, Shahbaz Youssefi <shabbyx@gmail.com> wrote:
>> Dear all,
>>
>> First, please CC replies to myself. Second, this is an RFC.
>>
>> I've been tampering with an idea for some time now and I've done some
>> research. Finally, I wrote it down here (a terrible place as it turned
>> out):
>>
>> http://shahbaz-youssefi.blogspot.it/2013/11/partially-privileged-applications.html
>>
>> and would like to know what you think. This idea requires an
>> improvement to the CPU architectures to allow unifying kernel and user
>> spaces and perform privileged instructions based on the location of
>> the instruction rather than a manually switched mode (or via traps).
>>
>> Please, do take a look at the link. I'm far from a kernel expert so
>> the idea may not be as rainbows and unicorns as it seems to me right
>> now. But it also may be. In that case, probably we need a push by
>> well-known people (i.e., Linus) to get the manufacturers to implement
>> the feature.
>>
>> At least from a developer's point of view, with this idea you could
>> gdb or even valgrind check the drivers in the very least with much
>> less chance of a kernel oops. How faster can you imagine debugging a
>> kernel module?
>
> So, we throw away 20 years of OS development and go back to hacky call
> gates? ;-)
>
>> Thanks,
>> An unfortunate soul who has to deal with buggy kernel modules
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> Thanks,
> //richard

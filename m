Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456Ab3DPWME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 18:12:04 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:56932 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965255Ab3DPWMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 18:12:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6ukQ7eys9-m_hgpscy9tTncPd1CL0O+n0sBZA-o0AbwdA@mail.gmail.com>
References: <1365445950-5736-1-git-send-email-gnurou@gmail.com>
 <20130416093259.BEB0E3E14C0@localhost> <CACxGe6ukQ7eys9-m_hgpscy9tTncPd1CL0O+n0sBZA-o0AbwdA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 16 Apr 2013 15:11:41 -0700
Message-ID: <CAAVeFuJ1iVZ24iU7yKSdjn_KSHThpYQFG0ccxS4Z0Qqg04v-tg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] remove GENERIC_GPIO
To: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chen Baozi <baozich@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant, Stephen,

On Tue, Apr 16, 2013 at 2:45 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> Grant, if this is ok with you, how shall we have this integrated into your
>>> branch? Half of this has been tested in my -next branch, and the present patches
>>> make the next half, should I resend you the whole series based on -next and
>>> withdraw my branch? This is a fast moving target, so we should try and shoot
>>> that duck as soon as we can! :)
>>
>> Most of your patches are already in linux-next in a separate branch, so
>> the first thing to do is get these remaining patches into that same
>> branch. As we discussed on IRC, you need to move yor current
>> "remove_generic_gpio" branch into your for_next branch so that it is
>> picked up by Stephen. There isn't any functional change there, but it
>> means that your series will be based on a defined point of Linus' tree
>> (v3.9-rc6) instead of an arbitrary commit point between -rc3 and -rc4.
>
> On second thought, no don't do this. Just leave it as is. It is more
> important to retain the test coverage you've already had in linux-next
> on these commits. Just apply the patches I've acked onto your existing
> for_next branch.

Ok, so I have added the 3 acked patches to the top of my for_next
branch and they will be pulled by Stephen for the next -next
iteration. I have also tried to merge the branch by myself into
today's next, and have been relieved to see that conflicts were
actually minimal (thanks to not including the GPIOLIB -> GPIO renaming
patch - definitely a good idea). Here is some information about how
the branch should look after merging:

"git grep CONFIG_GENERIC_GPIO" should return 0 hits whereas "git grep
'\bGENERIC_GPIO\b'" should return only one hit, in
Documentation/zh_CN/gpio.txt (Chen, I'm not sure if you intended to
leave this one in your documentation update patch?). Remaining
selectors or dependencies on GENERIC_GPIO should be turned into
GPIOLIB. Also the arc/ architecture defines GENERIC_GPIO once more,
this definition can be deleted.

There were only 3 or 4 conflicts to address on today's -next, and then
the kernel compiles just fine on the architectures I tried.

Thanks!
Alex.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab3ECQwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:52:05 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:46726 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab3ECQwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:52:03 -0400
Date: Fri, 3 May 2013 18:51:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [git pull] GPIO for v3.10
Message-ID: <20130503185148.600554bd@endymion.delvare>
In-Reply-To: <CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com>
References: <CACxGe6vr1kh2yqnG6kpASBGDUQrC7taBu00VWu6VG+qCO2u9QA@mail.gmail.com>
	<CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, 3 May 2013 09:14:44 -0700, Linus Torvalds wrote:
> On Fri, May 3, 2013 at 3:37 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> >
> > Here are the GPIO changes staged for v3.10. Please pull.
> 
> Grrr. These clearly have not been tested at all, and they break the
> allmodconfig build.
> 
> > Jean Delvare (2):
> >       gpio: ucb1400: Can be built as a module
> 
> The above one is pure and utter garbage. That driver cannot be built
> as a module, and clearly nobody ever even tested it.

Actually someone has, and that would be me, but definitely not in the
same context you did. Because for me it did build, see below.

> You have:
> 
>    void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data)
> 
> (which, btw, seems entirely unused), but then in the header file
> (remember: this is a totally unused function as far as I can tell) we
> have
> 
>    #ifdef CONFIG_GPIO_UCB1400
>    void __init ucb1400_gpio_set_data(struct ucb1400_gpio_data *data);
>    #else
>    static inline void ucb1400_gpio_set_data(struct ucb1400_gpio_data *data) {}
>    #endif
> 
> which means that in the modular case, you get
> 
>    drivers/gpio/gpio-ucb1400.c:106:13: error: redefinition of
> ‘ucb1400_gpio_set_data’
> 
> again, I see absolutely no way that (a) this piece of crap has ever
> been tested and (b) how /why that useless piece of shit even gets
> used.
> 
> I'm upset. How the f*ck did this get into your tree in the first
> place, and after it got into the tree, WHY THE HELL DID YOU SEND THIS
> CRAP TO ME?
> 
> The one-liner commit that enables this piece of shit is signed off by
> two people, has another person with a "Reviewed-by:" and there is no
> way in hell it was ever tested or anybody has ever looked at the
> driver in question. WTF?

I'm afraid you are slightly overreacting here :) We've been working
together for the past 8 years, I would think you know that I do not
push untested crap upstream.

> I'm going out on a limb here, and guessing that it wasn't in linux-next either.

This specific commit actually is in linux-next, and has been for 7 days
already:
https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-gpio.git/commit/?h=for-next&id=66791d8e8f9992ad13ee1fc0e4f0fe7534b095f8

> Piece of unadulterated shit.
> 
> Quite frankly, I'm not taking any GPIO changes from you this merge
> window. I only noticed this after having done two other merges on top
> of it, so now I'll have to go back and undo all of this, because quite
> frankly, I'm upset enough that I don't want to have any remains of
> this whole experience in my tree.

My patch is perfectly sane and correct, the only problem here is that
it depends on another patch from Marek Vasut (as the header comment
states, BTW.) That other patch has been for 3 weeks:
http://git.kernel.org/cgit/linux/kernel/git/sameo/mfd-next.git/commit/?id=360e64d8bbe7c78784d769a60d152804f5079577
which is why nobody complained.

The real problem here is that two patches which depended on each other
went to you through 2 different maintainer trees (mfd maintained by
Samuel Ortiz and gpio maintained by Grant L. & Linus W.), and the git
pull requests reached you in the wrong order. That doesn't make us all
irresponsible and lame contributors/maintainers, does it?

I am sorry for not noticing the problem when both maintainers applied
the two patches in question to their respective trees. It seems
everyone else involved missed that too.

Please accept my apologies for this human mistake. I'll do my best to
pay more attention next time.

Have a great week-end all,
-- 
Jean Delvare

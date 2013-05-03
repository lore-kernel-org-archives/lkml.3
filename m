Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab3ECRRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:17:44 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44237 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603Ab3ECRRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:17:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com>
References: <CACxGe6vr1kh2yqnG6kpASBGDUQrC7taBu00VWu6VG+qCO2u9QA@mail.gmail.com>
 <CA+55aFw9fbZBiZDC25j4A50NmsYbpwV-wUfWMpE_D7bEXQ-XVg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 May 2013 18:17:22 +0100
X-Google-Sender-Auth: JmsyLBJNfS4Y-V4oLGj6XVMQ44U
Message-ID: <CACxGe6s_0ejTS-i7n2mXUH540WXzWj+f4W51Y9THJn+7BBq51g@mail.gmail.com>
Subject: Re: [git pull] GPIO for v3.10
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 5:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> The one-liner commit that enables this piece of shit is signed off by
> two people, has another person with a "Reviewed-by:" and there is no
> way in hell it was ever tested or anybody has ever looked at the
> driver in question. WTF?
>
> I'm going out on a limb here, and guessing that it wasn't in linux-next either.

It's been in linux-next since April 29. The problem is that it depends
on the following commit which is in the mfd tree, which gets merged
into linux-next before the gpio tree. The following commit removes the
prototype that it breaks on. That is why linux-next didn't catch it,
but it doesn't change the fact that it never should have been
committed that way.

commit 360e64d8bbe7c78784d769a60d152804f5079577
Author: Marek Vasut <marex@denx.de>
Date:   Sun Apr 14 20:35:48 2013 +0200

    mfd: ucb1400: Pass ucb1400-gpio data through ac97 bus

    Cc: Jean Delvare <jdelvare@suse.de>
    Cc: Guenter Roeck <linux@roeck-us.net>
    Cc: Grant Likely <grant.likely@secretlab.ca>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Marek Vasut <marex@denx.de>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

And, no, I didn't do a full build test of that tree before sending it.
Linusw has been a huge help and offloaded a bunch of the gpio work and
keeping on top of the gpio driver patches. Not his fault though, I got
lazy seeing that it had already been in linux next and so didn't build
everything.

> Quite frankly, I'm not taking any GPIO changes from you this merge
> window. I only noticed this after having done two other merges on top
> of it, so now I'll have to go back and undo all of this, because quite
> frankly, I'm upset enough that I don't want to have any remains of
> this whole experience in my tree.

Very well. I do apologize am sorry for causing you extra work. There
is another series of GPIO changes that removes GENERIC_GPIO. Alex
Courbot has done all the leg work of getting them prepared, dealing
with the cross-tree conflicts and getting it into linux-next for
testing. That branch is completely separate from the other GPIO
changes. I'll get him to send you the pull request directly and you
can decide whether or not to pull it.

g.

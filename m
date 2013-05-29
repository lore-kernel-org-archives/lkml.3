Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab3E2Q2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:28:32 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:65311 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3E2Q20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:28:26 -0400
MIME-Version: 1.0
In-Reply-To: <51A4C9BA.40903@wwwdotorg.org>
References: <1368690525-32252-1-git-send-email-linus.walleij@stericsson.com>
	<519A8A57.9060007@wwwdotorg.org>
	<CACRpkdZieCmFnHCGUkv8EqcAtb3DA7dSZpimSdB4P81tZPJRoQ@mail.gmail.com>
	<519F8B02.1080000@wwwdotorg.org>
	<CACRpkdYxvBvYAnmp-p5WwB3QD0rd83qDcdg-BMhN7-2Jv8Oo_w@mail.gmail.com>
	<51A4C9BA.40903@wwwdotorg.org>
Date: Wed, 29 May 2013 18:28:26 +0200
Message-ID: <CACRpkdaC54jJxfPiaEborfuozHCgvH6vMzsQT_6kJsM-=6fedQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sink pinctrldev_list_mutex
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: ext Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 5:14 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> [Me]
>> But it'd be even cooler to actually just iterate over the
>> pinctrl_list och handles and orphan them, and later recouple
>> them if a driver is loaded back in.
>
> Hmm. What happens if the client driver wants to select a different state
> while the pinctrl driver itself isn't loaded? I'm not sure how workable
> that is. I think the only way to make it work would be to cache enough
> information in the struct pinctrl that it could be activated even if the
> driver wasn't loaded. That seems a little scary.

Yes it looks like that would lead to a bit of scalability problem in the
struct pinctrl. If for nothing else than for the fact that it will eat
memory and such :-(

> I'd be fine if there was a requirement to unload all drives that were
> clients of the pinctrl driver before you could unload the pinctrl
> driver, just like any other driver/subsystem. This would work fine at
> least for testing with just hogs, which while not great for full-system
> testing would surely be fine at least when first developing the pinctrl
> driver.

Yes ... so if we call
get_device(pctldev->dev)/put_device(pctldev->dev)
for any successful pinctrl_get() which is not a hog,
we increase the refcount so that the device core will disallow
unloading of the driver.

Now I need to figure out how to do that.

Yours,
Linus Walleij

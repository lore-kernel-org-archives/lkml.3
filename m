Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab3BINxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 08:53:44 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:55474 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3BINxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 08:53:43 -0500
MIME-Version: 1.0
In-Reply-To: <20130209093753.654C53E2C59@localhost>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
 <1359822572-26009-6-git-send-email-acourbot@nvidia.com> <CACRpkdaC3pu3tBZrw0Az226XEt6+AzJ_NiiCaLwV9o6NUZ8MQw@mail.gmail.com>
 <20130209093753.654C53E2C59@localhost>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Sat, 9 Feb 2013 22:53:22 +0900
X-Google-Sender-Auth: pc_hHHzDS5o0MauH4EYnNfgZNmQ
Message-ID: <CAAVeFuLW5pP=Kk7wh63eNAuycvEcXV1op6GkXyZwK85Gqz+DJQ@mail.gmail.com>
Subject: Re: [PATCH 4/9] gpiolib: use gpio_chips list in sysfs ops
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 6:37 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> However, this code is incorrect (it was incorrect before you touched it,
> so not your fault). Moving it to a list makes it a lot worse though
> because it introduces the possibility of dereferencing an invalid
> pointer. The hooks need to grab the spinlock before parsing the list.
>
> I've got a patch which I'll post. I'd appreciate it if you can test
> also.
>
> In actual fact, I'd like to replace the spinlock with a mutex, but that
> requires some auditing to make sure there aren't any users from an
> atomic context.

I thought about doing that as well actually, but left it for later. It
looks safe at first sight, but as you mention we cannot exclude a few
users will break as a consequence of such a switch.

In any case, I plan to give it a try once that big chunk is merged.

Alex.

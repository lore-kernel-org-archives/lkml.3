Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3BIKKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:10:07 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:36539 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3BIKKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:10:04 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/9] gpiolib: use gpio_chips list in sysfs ops
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
In-Reply-To: <CACRpkdaC3pu3tBZrw0Az226XEt6+AzJ_NiiCaLwV9o6NUZ8MQw@mail.gmail.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-6-git-send-email-acourbot@nvidia.com> <CACRpkdaC3pu3tBZrw0Az226XEt6+AzJ_NiiCaLwV9o6NUZ8MQw@mail.gmail.com>
Date: Sat, 09 Feb 2013 09:37:53 +0000
Message-Id: <20130209093753.654C53E2C59@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013 18:15:54 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> 
> > This makes the code both simpler and faster compared to parsing the GPIO
> > number space.
> >
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

However, this code is incorrect (it was incorrect before you touched it,
so not your fault). Moving it to a list makes it a lot worse though
because it introduces the possibility of dereferencing an invalid
pointer. The hooks need to grab the spinlock before parsing the list.

I've got a patch which I'll post. I'd appreciate it if you can test
also.

In actual fact, I'd like to replace the spinlock with a mutex, but that
requires some auditing to make sure there aren't any users from an
atomic context.

g.


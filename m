Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3CFBLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:11:06 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:34943 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab3CFBLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:11:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130306114452.a041ab0737783f9730c1486e@canb.auug.org.au>
References: <20130306114452.a041ab0737783f9730c1486e@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 6 Mar 2013 09:10:42 +0800
X-Google-Sender-Auth: vkdLQPfpaAoxliRlw6qUz53E8xs
Message-ID: <CACxGe6sZKRjSnwa-CHC1OhJoGP-ZQe4H2YbMYjDjNYcSdSyuow@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (gpio
 tree relatred)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Lartey <ian@slimlogic.co.uk>, Graeme Gregory <gg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 8:44 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/gpio/gpio-palmas.c: In function 'palmas_gpio_probe':
> drivers/gpio/gpio-palmas.c:173:2: error: implicit declaration of function 'is_palmas_charger' [-Werror=implicit-function-declaration]
> drivers/gpio/gpio-palmas.c:173:30: error: 'struct palmas' has no member named 'product_id'
>
> Caused by commit 82d4d6637fdf ("gpio/palmas: add in GPIO support for
> palmas charger").  I wonder if this was ever build tested. :-(

Probably not. Looks like this driver doesn't get enabled without the
associated option in MFD. I didn't go searching for it, so my build
tests didn't catch it. I'll drop the patch from my tree. Sorry for the
pain.

g.

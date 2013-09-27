Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3I0OZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:25:15 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:34562 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3I0OZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:25:14 -0400
MIME-Version: 1.0
In-Reply-To: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com>
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com>
Date: Fri, 27 Sep 2013 16:25:13 +0200
Message-ID: <CACRpkdZ=KK6YY0_HFDyieg9_WiqabxrQb4gLYgmiOnKBDU6SKw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: palmas: do not abort pin configuration for BIAS_DEFAULT
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sherman Yin <syin@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 2:48 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Recent movement of all configurations of pin in the single call of
> pin_config_set(), it is aborting configuration if BIAS_PULL_PIN_DEFAULT
> is selected as return of configuration.
>
> The original idea was to just avoid any update on register for pull up/down
> configuration if this option is selected.
>
> Fixing this by just bypassing any register update for BIAS_PULL_PIN_DEFAULT
> and continuing the remaining configuration.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

I've applied the patch as it just brings back the semantics before
commit 03b054e9696c3cbd3d5905ec96da15acd0a2fe8d
"pinctrl: Pass all configs to driver on pin_config_set()"

(Normally you should mention the above in your commit message
with patches like these that are regressions.)
But whatever.

Please look into the related issue pointed out by Stephen as well.

Yours,
Linus Walleij

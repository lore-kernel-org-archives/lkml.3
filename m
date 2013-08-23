Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3HWNbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:31:42 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62010 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab3HWNbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <1370521041-32318-27-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
	<1370521041-32318-27-git-send-email-lee.jones@linaro.org>
Date: Fri, 23 Aug 2013 15:31:40 +0200
Message-ID: <CACRpkdb+WEecBEuFtoDLv9k3vyi=o0nZcLfCeny-7+uxdNBryA@mail.gmail.com>
Subject: Re: [PATCH 26/33] ARM: ux500: Remove AUXDATA relating to SDI (MMC)
 clock-name bindings
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Signed-off-by: Lee Jones <lee.jones@linaro.org>
(...)
>         /* Requires DMA bindings. */
>         OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
> -       OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  &mop500_sdi0_data),
> -       OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  &mop500_sdi1_data),
> -       OF_DEV_AUXDATA("arm,pl18x", 0x80005000, "sdi2",  &mop500_sdi2_data),
> -       OF_DEV_AUXDATA("arm,pl18x", 0x80114000, "sdi4",  &mop500_sdi4_data),

This cannot be done. Ulf H would beat me up if I applied this.

The platform data there in the end is actually used.

Especially look at mop500_sdi0_data, it contains a lot of stuff that is
not yet DT:ed even (a task in its own right).

But as long as we keep this pdata we can still delete ATAGs support (as
per the second patch set pending) and get a clearer picture.

Yours,
Linus Walleij

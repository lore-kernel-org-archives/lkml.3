Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3HPOx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:53:57 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:63420 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3HPOxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:53:53 -0400
MIME-Version: 1.0
In-Reply-To: <1375889038-7953-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1375889038-7953-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Fri, 16 Aug 2013 16:53:53 +0200
Message-ID: <CACRpkdZX5tNmY0KcUrghv8TzVVP_vmgfxje+LMKpEbFfyQMTUA@mail.gmail.com>
Subject: Re: [PATCH] gpio: adnp: Fix segfault if request_threaded_irq fails
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 5:23 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:

> From: Lars Poeschel <poeschel@lemonage.de>
>
> In case request_threaded_irq inside adnp_irq_setup fails, the driver
> segfaults. This is because irq_domain_remove is called twice with
> the same pointer. First time in adnp_irq_setup and then a second time
> after leaving adnp_irq_setup in the error path of adnp_i2c_probe
> inside adnp_teardown.
> This fixes this by removing the call to irq_domain_remove from
> adnp_irq_setup.
>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

Patch applied.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaAaMmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:42:12 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:46874 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaAaMmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:42:11 -0500
MIME-Version: 1.0
In-Reply-To: <1390878162-22402-1-git-send-email-sonic.adi@gmail.com>
References: <1390878162-22402-1-git-send-email-sonic.adi@gmail.com>
Date: Fri, 31 Jan 2014 13:42:10 +0100
Message-ID: <CACRpkdb4Ogf5a-akRhtGgsZuFDY9ba9Jx_nyhUpYo7M9yFRy5w@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] pinctrl-adi2: change irq_base from usigned int to int
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 4:02 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Negative irq_base means there is no fixed Linux irq mappings are created from the platform data.
> The driver calls irq_create_mapping to allocate a virtual Linux irq.

Those IRQs are not any more "virtual" than any other Linux IRQ
so I don't like this way of putting things. They are dynamically
allocated though.

The whole "virq" thing is just one big confusion, somehow people
are under the impression that some IRQ numbers in the kernel
are more "real" than others just because they happen to map
1-to-1 to a certain HW IRQ on the primary IRQ controller, but this
is just pure luck. This is one reason we're trying to get rid of
IRQ numbers altogether (if that will ever go anywhere).

> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
> v2-changes:
>  - reword the patch description

I applied v1 anyway.

Yours,
Linus Walleij

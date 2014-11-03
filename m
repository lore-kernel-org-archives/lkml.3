Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaKCOLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:11:33 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37935 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbaKCOL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:11:29 -0500
MIME-Version: 1.0
In-Reply-To: <1414825380-15322-1-git-send-email-acourbot@nvidia.com>
References: <1414825380-15322-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 3 Nov 2014 15:11:28 +0100
Message-ID: <CACRpkdaaXxXCm9===0zaKW5QJsHFBznnERdFrcbtKLQhxygzhA@mail.gmail.com>
Subject: Re: [RFC] gpio: remove gpio_descs global array
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2014 at 8:03 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> The issue with this patch is its use of kzalloc() in gpiochip_add(), a
> function potentially called during early boot, before kzalloc() becomes
> usable. Hence its [RFC] status until we can find a solution for this or
> agree that this issue is actually never ran into (from which point can
> one use kzalloc()?)

So which driver requires that the gpiochip be statically defined...
I heard about early call but not *that* early.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab3LIQD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:03:28 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52659 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922Ab3LIQDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:03:24 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Chao Xu <caesarxuchao@gmail.com>
Cc: linux-omap@vger.kernel.org, santosh.shilimkar@ti.com,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, balbi@ti.com,
        nm@ti.com
Subject: Re: [RFC/RFT/PATCH V3] gpio: omap: refresh patch "be more aggressive with pm_runtime" against v3.12-rc5
References: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
	<1386477638-6331-1-git-send-email-caesarxuchao@gmail.com>
Date: Mon, 09 Dec 2013 08:03:21 -0800
In-Reply-To: <1386477638-6331-1-git-send-email-caesarxuchao@gmail.com> (Chao
	Xu's message of "Sat, 7 Dec 2013 22:40:38 -0600")
Message-ID: <87r49m8112.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chao Xu <caesarxuchao@gmail.com> writes:

> From: Felipe Balbi <balbi@ti.com>
>
> try to keep gpio block suspended as much as possible.

> Tested with pandaboard and a sysfs exported gpio.
>
> Signed-off-by: Felipe Balbi <balbi at ti.com>
>
> [caesarxuchao@gmail.com : Refreshed against v3.12-rc5, and added
> revision check to enable aggressive pm_runtime on OMAP4-only. Because
> am33xx_gpio_sysc.idlemodes seems to be wrongly marked as
> SIDLE_SMART_WKUP, which might cause missed interrupts with this patch.
> Tested on Pandaboard rev A2.]
> Signed-off-by: Chao Xu <caesarxuchao@gmail.com>

I have several problems with this patch.

First, the changelog is missing a lot of information.  In particular, nowhere
is it described what problem is this patch addressing  and how this
patch addresses that problem.

Second, I don't see any mention of off-mode, and I suspect there are
issues with off-mode here that are not being addressed.

Also, I *really* don't like any approach that is targetted at a single
SoC.

Kevin

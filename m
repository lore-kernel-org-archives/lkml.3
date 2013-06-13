Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab3FMSUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:20:09 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:61321 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3FMSUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <1371141522-29255-3-git-send-email-dianders@chromium.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
	<1371141522-29255-3-git-send-email-dianders@chromium.org>
Date: Thu, 13 Jun 2013 20:20:06 +0200
Message-ID: <CACRpkdZT_jvUzMmOrmwLOR5Gc2TWEp85kWa+yyMAp1bG3xrWXw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] pinctrl: exynos: ack level-triggered interrupts
 before unmasking
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, ilho215.lee@samsung.com,
        Eunki Kim <eunki_kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 6:38 PM, Doug Anderson <dianders@chromium.org> wrote:

> A level-triggered interrupt should be acked after the interrupt line
> becomes inactive and before it is unmasked, or else another interrupt
> will be immediately triggered.  Acking before or after calling the
> handler is not enough.
>
> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Greatly simplified using Tomasz's suggestion of irqd_get_trigger_type
> - Moved acking out of the bank spinlock since since it's not needed.
> - Linus W. has already applied parts 1 and 2, so not resending.

Thanks, this v2 version applied with Tomasz ACK.

Yours,
Linus Walleij

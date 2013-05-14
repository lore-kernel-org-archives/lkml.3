Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3ENI4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:56:47 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59894 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab3ENI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:56:45 -0400
MIME-Version: 1.0
In-Reply-To: <1368517100-22243-1-git-send-email-adam.lee@canonical.com>
References: <1368517100-22243-1-git-send-email-adam.lee@canonical.com>
Date: Tue, 14 May 2013 10:56:44 +0200
Message-ID: <CACRpkdbWzaKryuFcVjZRqmbzXBsFZm6er6ehuBEXWaWFWhg0wQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Add a capability for disabling mmc cards
From: Linus Walleij <linus.walleij@linaro.org>
To: Adam Lee <adam.lee@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Doug Anderson <dianders@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sebastian Rasmussen <sebras@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 9:38 AM, Adam Lee <adam.lee@canonical.com> wrote:

> On some systems we need a way to disable MMC card support in a MMC/SD
> card slot due to the legal concern.
>
> Add support in the core SD/MMC code to support this.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Adam Lee <adam.lee@canonical.com>

(...)
>  #define MMC_CAP2_NO_PRESCAN_POWERUP (1 << 14)  /* Don't power up before scan */
> +#define MMC_CAP2_NO_MMC                (1 << 15)       /* Only SD supported, not MMC */

I would name that MMC_CAP2_DISABLE_MMC_BUT_NOT_SD
because that is what it means.

People wanting to set that capability for said legal reasons
will not read the git log.

So also encode what you just said in the comment for the CAP
so it is crystal clear what this is for.

I'm a bit ambivalent about what kind of benefits this provides
to human users of the Linux kernel, while I do understand the
benefit it provides for legal bodies...

Yours,
Linus Walleij

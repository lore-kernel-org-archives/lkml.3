Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3FAFn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 01:43:29 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34079 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3FAFnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 01:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <1370038972-2318779-12-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
	<1370038972-2318779-12-git-send-email-arnd@arndb.de>
Date: Fri, 31 May 2013 22:43:23 -0700
Message-ID: <CAN8TOE8Y_2RMSrgMw7KwML88_1VA=QcJwuuMKEZpZCF5_dAQ=w@mail.gmail.com>
Subject: Re: [PATCH 11/15] iwlegacy: il_pm_ops is only provided for PM_SLEEP
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, May 31, 2013 at 3:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> This makes sure the conditionals for the declaration match the
> definition, so we provide the alternative
>
>  #else
>  #define IL_LEGACY_PM_OPS NULL
>  #endif
>
> in the correct cases. As suggested by Borislav Petkov, this removes
> the comments for the #else and #endif lines.

You seem to have missed the #endif line.

> drivers/built-in.o:(.data+0x57974): undefined reference to `il_pm_ops'
>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/iwlegacy/common.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
> index f8246f2..30dda98 100644
> --- a/drivers/net/wireless/iwlegacy/common.h
> +++ b/drivers/net/wireless/iwlegacy/common.h
> @@ -1832,14 +1832,14 @@ u32 il_usecs_to_beacons(struct il_priv *il, u32 usec, u32 beacon_interval);
>  __le32 il_add_beacon_time(struct il_priv *il, u32 base, u32 addon,
>                           u32 beacon_interval);
>
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  extern const struct dev_pm_ops il_pm_ops;
>
>  #define IL_LEGACY_PM_OPS       (&il_pm_ops)
>
> -#else /* !CONFIG_PM */
> +#else
>
> -#define IL_LEGACY_PM_OPS       NULL
> +#define
>
>  #endif /* !CONFIG_PM */

This should not be "!CONFIG_PM" any more.

Brian

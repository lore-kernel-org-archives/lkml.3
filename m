Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaJIUOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:14:39 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37733 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaJIUOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:14:36 -0400
Date: Thu, 9 Oct 2014 13:14:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Carlo Caione <carlo@caione.org>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.galvani@gmail.com
Subject: Re: [PATCH] ARM: meson: watchdog: remove magic value for reboot
Message-ID: <20141009201431.GA23397@roeck-us.net>
References: <1412884756-20943-1-git-send-email-carlo@caione.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412884756-20943-1-git-send-email-carlo@caione.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 09:59:16PM +0200, Carlo Caione wrote:
> This patch removes the magic value used for rebooting the board. This
> value is useless and leads to a static checker warning as reported by
> Dan Carpenter.
> 
> Signed-off-by: Carlo Caione <carlo@caione.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/meson_wdt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/meson_wdt.c b/drivers/watchdog/meson_wdt.c
> index 37f9f5ec..ef6a298 100644
> --- a/drivers/watchdog/meson_wdt.c
> +++ b/drivers/watchdog/meson_wdt.c
> @@ -51,7 +51,7 @@ struct meson_wdt_dev {
>  static int meson_restart_handle(struct notifier_block *this, unsigned long mode,
>  				void *cmd)
>  {
> -	u32 tc_reboot = MESON_WDT_DC_RESET | MESON_WDT_TC_EN | 100;
> +	u32 tc_reboot = MESON_WDT_DC_RESET | MESON_WDT_TC_EN;
>  	struct meson_wdt_dev *meson_wdt = container_of(this,
>  						       struct meson_wdt_dev,
>  						       restart_handler);
> -- 
> 1.9.1
> 

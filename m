Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaCKEBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 00:01:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50684 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaCKEBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 00:01:16 -0400
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: wireless: Kconfig: add missing dependency for airo_cs
References: <1398887.G3HYkOfaVN@wuerfel>
Date: Tue, 11 Mar 2014 12:01:04 +0800
In-Reply-To: <1398887.G3HYkOfaVN@wuerfel> (Arnd Bergmann's message of "Mon, 10
	Mar 2014 15:05:25 +0100")
Message-ID: <87pplt9yf3.fsf@will.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 22:05:25 +0800, Arnd Bergmann wrote:
> commit 4c59ff221e070 "wireless: Kconfig: add missing dependency" added a number
> of 'depends on CFG80211' statements, but missed the AIRO_CS driver that
> also causes the airo.c file to be built. This adds the (hopefully) last
> such missing statement

Thanks for the catch.

minor issue: commit log should be 'fails to be built'.

>     
> Cc: "Zhao, Gang" <gamerh2o@gmail.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index d1fab43..9c2c285 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -116,7 +116,7 @@ config AT76C50X_USB
>  
>  config AIRO_CS
>  	tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
> -	depends on PCMCIA && (BROKEN || !M32R)
> +	depends on CFG80211 && PCMCIA && (BROKEN || !M32R)
>  	select WIRELESS_EXT
>  	select WEXT_SPY
>  	select WEXT_PRIV

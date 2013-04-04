Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132Ab3DDOH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:07:59 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:33773 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760838Ab3DDOH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:07:58 -0400
Message-ID: <515D892A.20909@openwrt.org>
Date: Thu, 04 Apr 2013 16:07:38 +0200
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: giometti@enneenne.com, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] pps: hide more configuration symbols behind CONFIG_PPS
References: <20130108162754.GB7643@netboy.at.omicron.at> <1358267098-30789-1-git-send-email-florian@openwrt.org>
In-Reply-To: <1358267098-30789-1-git-send-email-florian@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/15/13 17:24, Florian Fainelli a écrit :
> This patch makes CONFIG_PPS_DEBUG and CONFIG_NTP_PPS be hidden if
> CONFIG_PPS is not selected, such that we are not prompted for these
> configuration options if CONFIG_PPS is not set.

It seems like this patch has not been merged, yet it is still applicable 
as of 3.9-rc. Andrew can you take it maybe? Thanks!

>
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
> Changes since v1:
> - dropped the depends on PPS which is now useless
>
>   drivers/pps/Kconfig |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
> index 982d16b..7512e98 100644
> --- a/drivers/pps/Kconfig
> +++ b/drivers/pps/Kconfig
> @@ -20,10 +20,10 @@ config PPS
>
>   	  To compile this driver as a module, choose M here: the module
>   	  will be called pps_core.ko.
> +if PPS
>
>   config PPS_DEBUG
>   	bool "PPS debugging messages"
> -	depends on PPS
>   	help
>   	  Say Y here if you want the PPS support to produce a bunch of debug
>   	  messages to the system log.  Select this if you are having a
> @@ -31,13 +31,15 @@ config PPS_DEBUG
>
>   config NTP_PPS
>   	bool "PPS kernel consumer support"
> -	depends on PPS && !NO_HZ
> +	depends on !NO_HZ
>   	help
>   	  This option adds support for direct in-kernel time
>   	  synchronization using an external PPS signal.
>
>   	  It doesn't work on tickless systems at the moment.
>
> +endif
> +
>   source drivers/pps/clients/Kconfig
>
>   source drivers/pps/generators/Kconfig
>


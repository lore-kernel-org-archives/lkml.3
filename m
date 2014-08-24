Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaHXVVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 17:21:07 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:32879 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaHXVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 17:21:05 -0400
Date: Sun, 24 Aug 2014 23:20:55 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] r8152: support firmware files
Message-ID: <20140824212055.GA30857@electric-eye.fr.zoreil.com>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
 <1394712342-15778-20-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-20-Taiwan-albertk@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 937d132..63542cc 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
[...]
> +static void rtl_request_firmware(struct r8152 *tp)
> +{
> +	char *fw_name = NULL;
> +
> +	if (tp->rtl_fw.fw)
> +		goto out_request;
> +
> +	switch (tp->version) {
> +	case RTL_VER_01:
> +		fw_name = "rtl_nic/rtl8152-1.fw";
> +		break;
> +	case RTL_VER_02:
> +		fw_name = "rtl_nic/rtl8152-2.fw";
> +		break;
> +	case RTL_VER_03:
> +		fw_name = "rtl_nic/rtl8153-1.fw";
> +		break;
> +	case RTL_VER_04:
> +		fw_name = "rtl_nic/rtl8153-2.fw";
> +		break;
> +	case RTL_VER_05:
> +		fw_name = "rtl_nic/rtl8153-3.fw";
> +		break;

The driver should use MODULE_FIRMWARE() for these files.

-- 
Ueimor

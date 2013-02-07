Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab3BGAd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:33:27 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:50327 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634Ab3BGAdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:33:24 -0500
Date: Thu, 7 Feb 2013 01:02:52 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] r8169: Modify the method for setting firmware
Message-ID: <20130207000252.GB2784@electric-eye.fr.zoreil.com>
References: <1360161987-3268-1-git-send-email-hayeswang@realtek.com> <1360161987-3268-3-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360161987-3268-3-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> Remove useless action PHY_READ_EFUSE, and define the new action
> PHY_MDIO_CHG.
> 
> PHY_MDIO_CHG is used to modify the mdio operation. By the way, the
> firmware could support setting mac ocp.
> 
[...]
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index d1bee4c..55a7fb5 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
[...]
> @@ -2321,8 +2339,15 @@ static void rtl_phy_write_fw(struct rtl8169_private *tp, struct rtl_fw *rtl_fw)
>  		case PHY_BJMPN:
>  			index -= regno;
>  			break;
> -		case PHY_READ_EFUSE:
> -			predata = rtl8168d_efuse_read(tp, regno);
> +		case PHY_MDIO_CHG:
> +			if (data == 0) {
> +				ops->write = org.write;
> +				ops->read = org.read;
> +			} else if (data == 1) {
> +				ops->write = mac_mcu_write;
> +				ops->read = mac_mcu_read;
> +			}

Did you check that none of rtl_nic/rtl8168d-{1, 2}.fw uses PHY_READ_EFUSE ?

-- 
Ueimor

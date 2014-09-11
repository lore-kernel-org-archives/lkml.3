Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaIKNaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:30:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52503 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbaIKNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:30:04 -0400
Date: Thu, 11 Sep 2014 09:29:58 -0400 (EDT)
Message-Id: <20140911.092958.40613877139856519.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: support VLAN
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-36-Taiwan-albertk@realtek.com>
References: <1394712342-15778-36-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Sep 2014 06:30:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Thu, 11 Sep 2014 20:16:24 +0800

> -	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CPCR);
> -	ocp_data &= ~CPCR_RX_VLAN;
> -	ocp_write_word(tp, MCU_TYPE_PLA, PLA_CPCR, ocp_data);
> +	if (tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
> +		rtl_rx_vlan_en(tp, true);
> +	else
> +		rtl_rx_vlan_en(tp, false);

	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);

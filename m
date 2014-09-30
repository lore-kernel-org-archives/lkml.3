Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbaI3Ung (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:43:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49647 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaI3Une (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:43:34 -0400
Date: Tue, 30 Sep 2014 16:43:32 -0400 (EDT)
Message-Id: <20140930.164332.1854194776177723982.davem@davemloft.net>
To: hau@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 02/10] r8169:add disable/enable RTL8168G pll
 function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412089230-10208-2-git-send-email-hau@realtek.com>
References: <1412089230-10208-1-git-send-email-hau@realtek.com>
	<1412089230-10208-2-git-send-email-hau@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Sep 2014 13:43:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chun-Hao Lin <hau@realtek.com>
Date: Tue, 30 Sep 2014 23:00:22 +0800

> @@ -4399,8 +4400,10 @@ static void r8168_pll_power_up(struct rtl8169_private *tp)
>  		break;
>  	case RTL_GIGA_MAC_VER_40:
>  	case RTL_GIGA_MAC_VER_41:
> +		RTL_W8(PMCH, RTL_R8(PMCH) | 0xc0);
>  		rtl_w1w0_eri(tp, 0x1a8, ERIAR_MASK_1111, 0xfc000000,
>  			     0x00000000, ERIAR_EXGMAC);
> +
>  		break;

There is no reason to add an empty line before the break; statement.

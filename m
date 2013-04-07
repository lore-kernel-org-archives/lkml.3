Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414Ab3DGVxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 17:53:18 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:52896 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934381Ab3DGVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 17:53:16 -0400
Date: Sun, 7 Apr 2013 23:53:03 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David R <david@unsolicited.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: AMD Vi error and lost networking with r8169
Message-ID: <20130407215303.GA28778@electric-eye.fr.zoreil.com>
References: <51616695.7080305@unsolicited.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51616695.7080305@unsolicited.net>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David R <david@unsolicited.net> :
> I'm been seeing some problems with my new ish AMD motherboard/processor
> combo and networking (r8169). I see the following page fault :-
> 
> Apr  7 12:25:14 david kernel: [156421.436545] AMD-Vi: Event logged
> [IO_PAGE_FAULT device=02:00.0 domain=0x0015 address=0x0000000000003000
> flags=0x0050]

Can you give the hack below a try ?

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 28fb50a..ed8625d 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4125,6 +4125,8 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_23:
 	case RTL_GIGA_MAC_VER_24:
 	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_35:
+	case RTL_GIGA_MAC_VER_36:
 		RTL_W32(RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
 		break;
 	default:

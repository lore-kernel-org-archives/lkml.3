Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3JCVBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:01:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40227 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3JCVBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:01:31 -0400
Date: Thu, 03 Oct 2013 17:01:26 -0400 (EDT)
Message-Id: <20131003.170126.2297161431158026731.davem@davemloft.net>
To: andrea.merello@gmail.com
Cc: jie.yang@atheros.com, xiong.huang@atheros.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atl1e: enable support for NETIF_F_RXALL and
 NETIF_F_RXCRC features
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380827917-22992-1-git-send-email-andrea.merello@gmail.com>
References: <1380827917-22992-1-git-send-email-andrea.merello@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 03 Oct 2013 14:01:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Merello <andrea.merello@gmail.com>
Date: Thu,  3 Oct 2013 21:18:37 +0200

> This patch allows (optionally, via ethtool) the atl1e NIC to:
> - Receive bad frames (runt, bad-fcs, etc..)
> - Receive full frames without stripping the FCS.
> 
> This has been tested on my board by injecting runt and bad-fcs
> frames with a FPGA-based device.
> 
> The particular scenario of receiving very short frames (<4 bytes)
> without passing FCS to the upper layer has been also tested:
> This could be potentially dangerous because the driver performs a
> 4 byte subtraction on the frame length, but I finally have NOT
> added anything to avoid this because it seems the NIC always
> discards frames so much short..
> If someone still have some reason to worry about this, please
> tell me.. I will add an explicit SW check..
> 
> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>

Looks good, applied, thanks Andrea.

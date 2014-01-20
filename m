Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaATED5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:03:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41137 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaATEDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:03:54 -0500
Date: Sun, 19 Jan 2014 20:03:52 -0800 (PST)
Message-Id: <20140119.200352.719528361166763885.davem@davemloft.net>
To: damuzi000@gmail.com
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH net-next v2] net: stmmac: fix NULL pointer
 dereference in stmmac_get_tx_hwtstamp
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389973679-2755-1-git-send-email-damuzi000@gmail.com>
References: <1389973679-2755-1-git-send-email-damuzi000@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Liu <damuzi000@gmail.com>
Date: Fri, 17 Jan 2014 23:47:59 +0800

> When timestamping is enabled, stmmac_tx_clean will call
> stmmac_get_tx_hwtstamp to get tx TS.
> But the skb can be NULL because the last of its tx_skbuff is NULL
> if this packet frame is filled in more than one descriptors.
> 
> To fix the issue, change the code:
> - Store TX skb to the tx_skbuff[] of frame's last segment.
> - Check skb is not NULL in stmmac_get_tx_hwtstamp.
> 
> Signed-off-by: Bruce Liu <damuzi000@gmail.com>

Looks a lot better, applied, thanks.

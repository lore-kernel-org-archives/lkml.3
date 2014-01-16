Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaAPA6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:58:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43186 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAPA6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:58:46 -0500
Date: Wed, 15 Jan 2014 16:58:45 -0800 (PST)
Message-Id: <20140115.165845.1813878173743840445.davem@davemloft.net>
To: damuzi000@gmail.com
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: fix NULL pointer dereference in
 stmmac_get_tx_hwtstamp
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389795967-2452-1-git-send-email-damuzi000@gmail.com>
References: <1389795967-2452-1-git-send-email-damuzi000@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Liu <damuzi000@gmail.com>
Date: Wed, 15 Jan 2014 22:26:07 +0800

> When timestamping is enabled, stmmac_tx_clean will call
> stmmac_get_tx_hwtstamp to get tx TS.
> But the skb can be NULL because the last of its tx_skbuff is NULL
> if this packet frame is filled in more than one descriptors.
> 
> Signed-off-by: Bruce Liu <damuzi000@gmail.com>

Sometimes the cure is worse than the disease.

Your change means that every multi-segment packet will never have
it's timestamp properly recorded, which is of course bogus.

You need to change this code such that the SKB from the first
descriptor is maintained so that we can pass it into
stmmac_get_tx_hwtstamp() at the appropriate time.

Thanks.

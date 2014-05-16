Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992480AbaEPXQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:16:00 -0400
Received: from mail.ispras.ru ([83.149.199.45]:57087 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbaEPXP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:15:59 -0400
Message-ID: <53769C2A.8050803@ispras.ru>
Date: Sat, 17 May 2014 03:15:54 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ldv-project@linuxtesting.org
Subject: [BUG] might sleep functions in atomic context in stmmac_resume()
In-Reply-To: 1384774256-10039-1-git-send-email-srinivas.kandagatla@st.com
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are calls to might sleep functions in atomic context in
stmmac_resume():
- the first one is clk_prepare_enable(priv->stmmac_clk);
- the second one is stmmac_hw_setup()
-> init_dma_desc_rings()
  -> ﻿stmmac_init_rx_buffers()
    -> __netdev_alloc_skb(GFP_KERNEL)

What is the purpose of spin_lock_irqsave(&priv->lock, flags) section?
What does it protect against?

Found by Linux Driver Verification project (linuxtesting.org).

--
Alexey Khoroshilov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org

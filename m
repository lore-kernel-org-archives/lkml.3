Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaESG6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:58:04 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:49251 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbaESG6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:58:01 -0400
Message-ID: <5379AB55.2050003@st.com>
Date: Mon, 19 May 2014 08:57:25 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [BUG] might sleep functions in atomic context in stmmac_resume()
References: <53769C2A.8050803@ispras.ru>
In-Reply-To: <53769C2A.8050803@ispras.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.52.138.2]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-18_03:2014-05-17,2014-05-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexey

On 5/17/2014 1:15 AM, Alexey Khoroshilov wrote:
> There are calls to might sleep functions in atomic context in
> stmmac_resume():
> - the first one is clk_prepare_enable(priv->stmmac_clk);
> - the second one is stmmac_hw_setup()
> -> init_dma_desc_rings()
>    -> ﻿stmmac_init_rx_buffers()
>      -> __netdev_alloc_skb(GFP_KERNEL)
>
> What is the purpose of spin_lock_irqsave(&priv->lock, flags) section?
> What does it protect against?

Some part of this driver, especially on PM stuff, has been reworked
time ago.
I have in plan to do further tests and investigations
also to understand and try to solve this kind of issues. I do not
want to see this kind of BUGs. Also I have some other patches on
other pending problem I will submit to be reviewed.
I hope to start doing this task in the incoming days.

BR
peppe

>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> --
> Alexey Khoroshilov
> Linux Verification Center, ISPRAS
> web: http://linuxtesting.org
>
>


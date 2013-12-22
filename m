Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab3LVJgC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 04:36:02 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3LVJf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 04:35:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/5] drivers: net: APM X-Gene SoC Ethernet driver error handling
Date: Sun, 22 Dec 2013 10:34:56 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Iyappan Subramanian <isubramanian@apm.com>, davem@davemloft.net,
        devicetree@vger.kernel.org, gregkh@linuxfoundation.org,
        patches@apm.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jcm@redhat.com, Keyur Chudgar <kchudgar@apm.com>,
        Ravi Patel <rapatel@apm.com>
References: <1387597376-29303-1-git-send-email-isubramanian@apm.com> <1387597376-29303-5-git-send-email-isubramanian@apm.com>
In-Reply-To: <1387597376-29303-5-git-send-email-isubramanian@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312221034.56313.arnd@arndb.de>
X-Provags-ID: V02:K0:ioROWxCh2AIPsc0h/zzCrGvYF+C2e6QAMIyBWIkzFVw
 Rbx6Jd6vO83yK4NeutpDOcuaOCr7hf2NY1QImTmjwI81WGM6iR
 DHwIEKP3qkYogv/n7q6cvT4K2VAj64U3Zi3VLF6hDp3Zxvykp0
 wY64KV7tBrko9FHectR1mlsIUYyBYmddu+jKNCyQJqeHiBd8sm
 cBc5JbLshIcMa+s5ml+daU2V9567K4o5t6fKwLFuoxEMY1S3ae
 g8brrmSHLwo5gAwItHrIeOZbj6SzFfS4hMx3t0yoYkguX4wGbE
 Sg/wxCgkWPQlCZ8bBZRg/oaiDu8VPRjeIjaCBnZp3iTJfRYza2
 uJAUk6Io5WdG4UvW3zOM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 December 2013, Iyappan Subramanian wrote:

> +#define CFG_RSIF_FPBUFF_TIMEOUT_EN_WR(src) \
> +	(((u32)(src)<<31) & 0x80000000)
> +#define RSIF_LCL_RXBUF_FIFO_OVERFL_INTR_RXPRT10_MASK                 0x20000000
> +#define RSIF_LCL_RXBUF_FIFO_OVERFL_INTR_RXPRT10_RD(src) \
> +	(((src) & 0x20000000)>>29)
> +#define RSIF_LCL_RXBUF_FIFO_UNDERFL_INTR_RXPRT10_MASK                0x10000000
> +#define RSIF_LCL_RXBUF_FIFO_UNDERFL_INTR_RXPRT10_RD(src) \
> +	(((src) & 0x10000000)>>28)
> +#define RSIF_CHKSUM_BUFF_FIFO_OVERFL_INTR_RXPRT10_MASK               0x08000000
> +#define RSIF_CHKSUM_BUFF_FIFO_OVERFL_INTR_RXPRT10_RD(src) \
> +	(((src) & 0x08000000)>>27)
> +#define RSIF_CHKSUM_BUFF_FIFO_UNDERFL_INTR_RXPRT10_MASK              0x04000000
> +#define RSIF_CHKSUM_BUFF_FIFO_UNDERFL_INTR_RXPRT10_RD(src) \
> +	(((src) & 0x04000000)>>26)
> +#define RSIF_TIMESTAMP_BUFF_FIFO_OVERFL_INTR_RXPRT10_MASK            0x02000000
> +#define RSIF_TIMESTAMP_BUFF_FIFO_OVERFL_INTR_RXPRT10_RD(src) \
> +	(((src) & 0x02000000)>>25)
> +#define RSIF_TIMESTAMP_BUFF_FIFO_UNDERFL_INTR_RXPRT10_MASK           0x01000000
> +#define RSIF_TIMESTAMP_BUFF_FIFO_UNDERFL_INTR_RXPRT10_RD(src) \
> +	(((src) & 0x01000000)>>24)
> +#define RSIF_ERR_BUFF_FIFO_OVERFL_INTR_RXPRT10_MASK                  0x00800000
> +#define RSIF_ERR_BUFF_FIFO_OVERFL_INTR_RXPRT10_RD(src) \
> +	(((src) & 0x00800000)>>23)
> +#define RSIF_ERR_BUFF_FIFO_UNDERFL_INTR_RXPRT10_MASK                 0x00400000
> +#define RSIF_ERR_BUFF_FIFO_UNDERFL_INTR_RXPRT10_RD(src) \
> +	(((src) & 0x00400000)>>22)
> +#define RSIF_CLEBUFF_FIFO_OVERFL_INTR_RXPRT10_MASK                   0x00200000
> +#define RSIF_CLEBUFF_FIFO_OVERFL_INTR_RXPRT10_RD(src) \
> +	(((src) & 0x00200000)>>21)

I think you can just remove all the above obfuscation, since all you ever
do is this:

> +	rc = xgene_enet_rd(priv, BLOCK_MCX_MAC_CSR, MAC_INT_REG0_ADDR, &data);
> +	if (data) {
> +		pr_err("Received MAC Error Interrupt\n");
> +
> +		if (ICM_DATA_FIFO_UNDERFL_INTR_PRT10_RD(data)) {
> +			pr_err("RxPort1 ICM Data fifo underflow intr\n");
> +			int_mask |= ICM_DATA_FIFO_UNDERFL_INTR_PRT10_MASK;
> +		}
> +		if (ICM_DATA_FIFO_OVERFL_INTR_PRT10_RD(data)) {
> +			pr_err("RxPort1 ICM Data fifo overflow intr\n");
> +			int_mask |= ICM_DATA_FIFO_OVERFL_INTR_PRT10_MASK;
> +		}
> +		if (ICM_CTRL_FIFO_UNDERFL_INTR_PRT10_RD(data)) {
> +			pr_err("RxPort1 ICM Ctrl fifo underflow intr\n");
> +			int_mask |= ICM_CTRL_FIFO_UNDERFL_INTR_PRT10_MASK;
> +		}
> +		if (ICM_CTRL_FIFO_OVERFL_INTR_PRT10_RD(data)) {
> +			pr_err("RxPort1 ICM Ctrl fifo overflow intr\n");
> +			int_mask |= ICM_CTRL_FIFO_OVERFL_INTR_PRT10_MASK;
> +		}
> +		if (ECM_DATA_FIFO_UNDERN_INTR_PRT10_RD(data)) {
> +			pr_err("RxPort1 ECM Data fifo underrun intr\n");
> +			int_mask |= ECM_DATA_FIFO_UNDERN_INTR_PRT10_MASK;
> +		}

So there is one string you print per bit. Just use an array of strings
and for_each_set_bit() loop.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaDCS2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:28:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40367 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaDCS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:28:49 -0400
Date: Thu, 3 Apr 2014 13:25:21 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 3/9] crypto: qce: Add dma and sg helpers
Message-ID: <20140403182520.GH28265@joshc.qualcomm.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
 <1396541886-10966-4-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396541886-10966-4-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitworthy comments :).

On Thu, Apr 03, 2014 at 07:18:00PM +0300, Stanimir Varbanov wrote:
[..]
> +++ b/drivers/crypto/qce/dma.c
[..]
> +int qce_dma_request(struct device *dev, struct qce_dma_data *dma)
> +{
> +	unsigned int memsize;
> +	void *va;
> +	int ret;
> +
> +	dma->txchan = dma_request_slave_channel_reason(dev, "tx");
> +	if (IS_ERR(dma->txchan)) {
> +		ret = PTR_ERR(dma->txchan);
> +		return ret;
> +	}
> +
> +	dma->rxchan = dma_request_slave_channel_reason(dev, "rx");
> +	if (IS_ERR(dma->rxchan)) {
> +		ret = PTR_ERR(dma->rxchan);
> +		goto error_rx;
> +	}
> +
> +	memsize = QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ;
> +	va = kzalloc(memsize, GFP_KERNEL);
> +	if (!va) {
> +		ret = -ENOMEM;
> +		goto error_nomem;
> +	}
> +
> +	dma->result_buf = va;
> +	dma->ignore_buf = dma->result_buf + QCE_RESULT_BUF_SZ;
> +
> +	return 0;
> +error_nomem:
> +	if (!IS_ERR(dma->rxchan))

How could this condition ever be false?

> +		dma_release_channel(dma->rxchan);
> +error_rx:
> +	if (!IS_ERR(dma->txchan))

Same here.

> +		dma_release_channel(dma->txchan);
> +	return ret;
> +}

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

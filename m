Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaDDIt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:49:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56783 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaDDItW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:49:22 -0400
Message-ID: <533E720F.6050609@mm-sol.com>
Date: Fri, 04 Apr 2014 11:49:19 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 3/9] crypto: qce: Add dma and sg helpers
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-4-git-send-email-svarbanov@mm-sol.com> <20140403182520.GH28265@joshc.qualcomm.com>
In-Reply-To: <20140403182520.GH28265@joshc.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 09:25 PM, Josh Cartwright wrote:
> Nitworthy comments :).
> 
> On Thu, Apr 03, 2014 at 07:18:00PM +0300, Stanimir Varbanov wrote:
> [..]
>> +++ b/drivers/crypto/qce/dma.c
> [..]
>> +int qce_dma_request(struct device *dev, struct qce_dma_data *dma)
>> +{
>> +	unsigned int memsize;
>> +	void *va;
>> +	int ret;
>> +
>> +	dma->txchan = dma_request_slave_channel_reason(dev, "tx");
>> +	if (IS_ERR(dma->txchan)) {
>> +		ret = PTR_ERR(dma->txchan);
>> +		return ret;
>> +	}
>> +
>> +	dma->rxchan = dma_request_slave_channel_reason(dev, "rx");
>> +	if (IS_ERR(dma->rxchan)) {
>> +		ret = PTR_ERR(dma->rxchan);
>> +		goto error_rx;
>> +	}
>> +
>> +	memsize = QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ;
>> +	va = kzalloc(memsize, GFP_KERNEL);
>> +	if (!va) {
>> +		ret = -ENOMEM;
>> +		goto error_nomem;
>> +	}
>> +
>> +	dma->result_buf = va;
>> +	dma->ignore_buf = dma->result_buf + QCE_RESULT_BUF_SZ;
>> +
>> +	return 0;
>> +error_nomem:
>> +	if (!IS_ERR(dma->rxchan))
> 
> How could this condition ever be false?

Good catch. This is a leftover after error path restructuring. Will fix
it on next version.

-- 
regards,
Stan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaD1IAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:00:21 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:45871 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaD1IAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:00:19 -0400
Date: Mon, 28 Apr 2014 16:00:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-arm-msm@vger.kernel.org,
        Mona Hossain <mhossain@codeaurora.org>,
        Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
        Zhen Kong <zkong@codeaurora.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/9] crypto: qce: Add ablkcipher algorithms
Message-ID: <20140428080006.GA14510@gondor.apana.org.au>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
 <1397479725-20954-5-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397479725-20954-5-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 03:48:40PM +0300, Stanimir Varbanov wrote:
>
> +	if (IS_AES(flags)) {
> +		switch (keylen) {
> +		case AES_KEYSIZE_128:
> +		case AES_KEYSIZE_256:
> +			break;
> +		default:
> +			goto badkey;

You need to support 192 here.  If the hardware doesn't do that
you can work around it by using a software fallback.

In general you need to provide everything that is supported by
the generic software implementation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

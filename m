Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbaD3AD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:03:57 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:38752 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaD3ADz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:03:55 -0400
Date: Wed, 30 Apr 2014 08:03:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        Mona Hossain <mhossain@codeaurora.org>,
        Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
        Zhen Kong <zkong@codeaurora.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/9] crypto: qce: Add core driver implementation
Message-ID: <20140430000340.GA32173@gondor.apana.org.au>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
 <1397479725-20954-2-git-send-email-svarbanov@mm-sol.com>
 <20140428085016.GA16275@gondor.apana.org.au>
 <535FB956.5020600@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535FB956.5020600@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:38:14PM +0300, Stanimir Varbanov wrote:
>
> This is new for me because I saw similar code in cryptd.c where in
> cryptd_queue_worker() (workqueue context) the backlog->complete() is
> called outside of local_bh_disable().

That's what I thought :)

If you dig deeper you'll find that when cryptd calls the actual
completion functions (rather than its own) it disables BH.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

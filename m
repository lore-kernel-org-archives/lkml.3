Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaDKUMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:12:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32968 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaDKUM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:12:29 -0400
Date: Fri, 11 Apr 2014 13:12:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 5/9] crypto: qce: Adds sha and hmac transforms
Message-ID: <20140411201227.GA20486@codeaurora.org>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
 <1396541886-10966-6-git-send-email-svarbanov@mm-sol.com>
 <20140409000931.GN9985@codeaurora.org>
 <5346AD64.1000409@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5346AD64.1000409@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Stanimir Varbanov wrote:
> On 04/09/2014 03:09 AM, Stephen Boyd wrote:
> > On 04/03, Stanimir Varbanov wrote:
> > 
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int qce_ahash_import(struct ahash_request *req, const void *in)
> >> +{
> >> +	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
> >> +	u32 flags = rctx->flags;
> >> +	bool hmac = IS_SHA_HMAC(flags);
> >> +	int ret;
> >> +
> >> +	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
> >> +		struct sha1_state *state = (struct sha1_state *)in;
> > 
> > Unnecessary cast from void *.
> 
> Nope, "in" is "const void *". Cast is needed to avoid compiler warnings.
> 

Ouch. Why are we casting away const? It should be possible to
make qce_import_common() take const state and buffer arguments?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

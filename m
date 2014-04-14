Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaDNIXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:23:41 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50360 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbaDNIXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:23:39 -0400
Message-ID: <534B9B0A.2080602@mm-sol.com>
Date: Mon, 14 Apr 2014 11:23:38 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 5/9] crypto: qce: Adds sha and hmac transforms
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-6-git-send-email-svarbanov@mm-sol.com> <20140409000931.GN9985@codeaurora.org> <5346AD64.1000409@mm-sol.com> <20140411201227.GA20486@codeaurora.org>
In-Reply-To: <20140411201227.GA20486@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 04/11/2014 11:12 PM, Stephen Boyd wrote:
> On 04/10, Stanimir Varbanov wrote:
>> On 04/09/2014 03:09 AM, Stephen Boyd wrote:
>>> On 04/03, Stanimir Varbanov wrote:
>>>
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int qce_ahash_import(struct ahash_request *req, const void *in)
>>>> +{
>>>> +	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
>>>> +	u32 flags = rctx->flags;
>>>> +	bool hmac = IS_SHA_HMAC(flags);
>>>> +	int ret;
>>>> +
>>>> +	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
>>>> +		struct sha1_state *state = (struct sha1_state *)in;
>>>
>>> Unnecessary cast from void *.
>>
>> Nope, "in" is "const void *". Cast is needed to avoid compiler warnings.
>>
> 
> Ouch. Why are we casting away const? It should be possible to
> make qce_import_common() take const state and buffer arguments?
> 

Sure, that's possible. Thanks!


-- 
regards,
Stan

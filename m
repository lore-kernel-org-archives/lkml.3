Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3AXMcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:32:21 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:46589 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab3AXMcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:32:14 -0500
Date: Thu, 24 Jan 2013 13:32:10 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tom St Denis <tstdenis@elliptictech.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] CMAC support for CryptoAPI, fixed patch issues, indent,
 and testmgr build issues
Message-ID: <20130124123210.GK9147@secunet.com>
References: <20130124094337.GJ9147@secunet.com>
 <20130124112410.8535.75598.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124112410.8535.75598.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 24 Jan 2013 12:32:10.0519 (UTC) FILETIME=[D48EF270:01CDFA2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 01:25:46PM +0200, Jussi Kivilinna wrote:
> 
> Maybe it would be cleaner to not mess with pfkeyv2.h at all, but instead mark algorithms that do not support pfkey with flag. See patch below.
> 

Yes, would be an option too. I would be fine with that,
but let's here if someone else has an opinion on this.
Anyway, we need a solution to integrate Tom's patch soon.

> Then I started looking up if sadb_alg_id is being used somewhere outside pfkey. Seems that its value is just being copied around.. but at "http://lxr.linux.no/linux+v3.7/net/xfrm/xfrm_policy.c#L1991" it's used as bit-index. So do larger values than 31 break some stuff? Can multiple algorithms have same sadb_alg_id value? Also in af_key.c, sadb_alg_id being used as bit-index.
> 

Herbert tried to address this already in git commit c5d18e984
([IPSEC]: Fix catch-22 with algorithm IDs above 31) some years
ago.

But this looks still messy. If the aalgos, ealgos and calgos mask is ~0, 
we allow all algorithms. If this is not the case, xfrm and pfkey check
the aalgos mask against the algorithm ID, only pfkey checks the ealgo
mask and noone checks the calgos mask.


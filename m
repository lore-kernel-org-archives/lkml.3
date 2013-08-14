Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3HNKtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:49:52 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:42443 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932467Ab3HNKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:49:49 -0400
Date: Wed, 14 Aug 2013 20:49:40 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: nx - fix concurrency issue
Message-ID: <20130814104937.GC13403@gondor.apana.org.au>
References: <1376344177-7205-1-git-send-email-mhcerri@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376344177-7205-1-git-send-email-mhcerri@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 06:49:37PM -0300, Marcelo Cerri wrote:
> The NX driver uses the transformation context to store several fields
> containing data related to the state of the operations in progress.
> Since a single tfm can be used by different kernel threads at the same
> time, we need to protect the data stored into the context.
> 
> This patch makes use of spin locks to protect the data where a race
> condition can happen.
> 
> Reviewed-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
> Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

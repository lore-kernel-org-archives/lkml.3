Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967215AbaFTSms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:42:48 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:34598 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966855AbaFTSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:42:37 -0400
Date: Sat, 21 Jun 2014 02:42:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: George Spelvin <linux@horizon.com>
Cc: tim.c.chen@linux.intel.com, james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: crc32c-pclmul - Shrink K_table to 32-bit words
Message-ID: <20140620184228.GI3169@gondor.apana.org.au>
References: <1401469271.2970.472.camel@schen9-DESK>
 <20140607030858.15508.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140607030858.15508.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:08:58PM -0400, George Spelvin wrote:
> There's no need for the K_table to be made of 64-bit words.  For some
> reason, the original authors didn't fully reduce the values modulo the
> CRC32C polynomial, and so had some 33-bit values in there.  They can
> all be reduced to 32 bits.
> 
> Doing that cuts the table size in half.  Since the code depends on both
> pclmulq and crc32, SSE 4.1 is obviously present, so we can use pmovzxdq
> to fetch it in the correct format.
> 
> This adds (measured on Ivy Bridge) 1 cycle per main loop iteration
> (CRC of up to 3K bytes), less than 0.2%.  The hope is that the reduced
> D-cache footprint will make up the loss in other code.
> 
> Two other related fixes:
> * K_table is read-only, so belongs in .rodata, and
> * There's no need for more than 8-byte alignment
> 
> Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: George Spelvin <linux@horizon.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

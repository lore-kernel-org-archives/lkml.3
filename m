Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3DZMwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:52:51 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:43423 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420Ab3DZMwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:52:49 -0400
Date: Fri, 26 Apr 2013 20:52:24 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Erdinc Ozturk <erdinc.ozturk@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/4] Wrap crc_t10dif function all to use crypto
 transform framework
Message-ID: <20130426125224.GA4855@gondor.apana.org.au>
References: <cover.1366214842.git.tim.c.chen@linux.intel.com>
 <ea4271721b5ca130849b03da4f172f12f66e5628.1366214842.git.tim.c.chen@linux.intel.com>
 <20130425132203.GA29501@gondor.apana.org.au>
 <1366910910.27102.126.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910910.27102.126.camel@schen9-DESK>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 10:28:30AM -0700, Tim Chen wrote:
>
> @@ -51,6 +54,98 @@ static const __u16 t10_dif_crc_table[256] = {
>  	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
>  };
>  
> +#ifdef CONFIG_CRYPTO_CRCT10DIF

No need for ifdefs, just make it unconditional like the crc32c
case.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

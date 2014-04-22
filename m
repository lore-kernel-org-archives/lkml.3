Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaDVX7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:59:38 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44386 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaDVX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:59:06 -0400
X-Auth-Info: YvAYGI/lnlbIfUrUZLfWh+Jp4o8UV8aAZe0GBeoBZk0=
From: Marek Vasut <marex@denx.de>
To: Christian Engelmayer <cengelma@gmx.at>
Subject: Re: [PATCH 1/3] crypto: Fix potential leak in test_aead_speed() if aad_size is too big
Date: Wed, 23 Apr 2014 01:33:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20140421204439.7999f1c6@spike> <20140421204559.75b8aa71@spike>
In-Reply-To: <20140421204559.75b8aa71@spike>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404230133.05256.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2014 at 08:45:59 PM, Christian Engelmayer wrote:
> Fix a potential memory leak in the error handling of test_aead_speed(). In
> case the size check on the associate data length parameter fails, the
> function goes through the wrong exit label. Reported by Coverity - CID
> 1163870.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
>  crypto/tcrypt.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 870be7b..1856d7f 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -282,6 +282,11 @@ static void test_aead_speed(const char *algo, int enc,
> unsigned int sec, unsigned int *b_size;
>  	unsigned int iv_len;
> 
> +	if (aad_size >= PAGE_SIZE) {

On an unrelated note ... Won't if (aad_size > PAGE_SIZE) be sufficient here?

Cheers!

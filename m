Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122AbaCSNwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:52:11 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:37873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933853AbaCSNwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:52:09 -0400
Message-ID: <1395237113.4142.5.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v3] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: behanw@converseincode.com
Cc: linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>,
        =?ISO-8859-1?Q?Vin=EDcius?= Tinti <viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Date: Wed, 19 Mar 2014 14:51:53 +0100
In-Reply-To: <1395199933-4686-1-git-send-email-behanw@converseincode.com> (sfid-20140319_043225_892297_337F53BC)
References: <CABikg9x+Z95bHcDc6iu5hBvRNO-ibM8-34_qA+OA_FjB52SPMw@mail.gmail.com>
	 <1395199933-4686-1-git-send-email-behanw@converseincode.com>
	 (sfid-20140319_043225_892297_337F53BC)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm confused.

On Tue, 2014-03-18 at 20:32 -0700, behanw@converseincode.com wrote:


>  	struct scatterlist assoc, pt, ct[2];
> -	struct {
> -		struct aead_request	req;
> -		u8			priv[crypto_aead_reqsize(tfm)];
> -	} aead_req;
>  
> -	memset(&aead_req, 0, sizeof(aead_req));
> +	char aead_req_data[sizeof(struct aead_request) +
> +		crypto_aead_reqsize(tfm)]
> +		__aligned(__alignof__(struct aead_request));

This looks fine, though I'd argue the blank lines before/after it
shouldn't be there, and the indentation should be a bit different, but I
was willing to clean that up.

>  int ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
>  			      u8 *data, size_t data_len, u8 *mic)
>  {
>  	struct scatterlist assoc, pt, ct[2];
> -	struct {
> -		struct aead_request	req;
> -		u8			priv[crypto_aead_reqsize(tfm)];
> -	} aead_req;
>  
> -	memset(&aead_req, 0, sizeof(aead_req));
> +	char aead_req_data[sizeof(struct aead_request) +
> +				crypto_aead_reqsize(tfm) +
> +				CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;

But why does the second instance use a completely different size/align?

johannes


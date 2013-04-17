Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966263Ab3DQR7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:59:05 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:53517 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965571Ab3DQR6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:58:50 -0400
Message-ID: <516EE2D7.5040301@iki.fi>
Date: Wed, 17 Apr 2013 20:58:47 +0300
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Erdinc Ozturk <erdinc.ozturk@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/4] Simple correctness and speed test for CRCT10DIF hash
References: <cover.1366120266.git.tim.c.chen@linux.intel.com> <de2e172b3c5b5d2ce77978be56aaa8b84272f5d6.1366120266.git.tim.c.chen@linux.intel.com>
In-Reply-To: <de2e172b3c5b5d2ce77978be56aaa8b84272f5d6.1366120266.git.tim.c.chen@linux.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.04.2013 19:20, Tim Chen wrote:
> These are simple tests to do sanity check of CRC T10 DIF hash.  The
> correctness of the transform can be checked with the command
> 	modprobe tcrypt mode=47
> The speed of the transform can be evaluated with the command
> 	modprobe tcrypt mode=320
> 
> Set the cpu frequency to constant and turn turbo off when running the
> speed test so the frequency governor will not tweak the frequency and
> affects the measurements.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> Tested-by: Keith Busch <keith.busch@intel.com>
<snip>
>  
> +#define CRCT10DIF_TEST_VECTORS	2
> +static struct hash_testvec crct10dif_tv_template[] = {
> +	{
> +		.plaintext = "abc",
> +		.psize  = 3,
> +#ifdef __LITTLE_ENDIAN
> +		.digest = "\x3b\x44",
> +#else
> +		.digest = "\x44\x3b",
> +#endif
> +	}, {
> +		.plaintext =
> +		"abcddddddddddddddddddddddddddddddddddddddddddddddddddddd",
> +		.psize  = 56,
> +#ifdef __LITTLE_ENDIAN
> +		.digest = "\xe3\x9c",
> +#else
> +		.digest = "\x9c\xe3",
> +#endif
> +		.np     = 2,
> +		.tap    = { 28, 28 }
> +	}
> +};
> +

Are these large enough to test all code paths in the PCLMULQDQ implementation?

-Jussi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3CXVxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 17:53:05 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:41621 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3CXVxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 17:53:02 -0400
Message-ID: <514F75BB.3080501@iki.fi>
Date: Sun, 24 Mar 2013 23:52:59 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 06/11] Create module providing optimized SHA256 routines
 using SSSE3, AVX or AVX2 instructions.
References: <cover.1363961999.git.tim.c.chen@linux.intel.com> <1363987761.8972.60.camel@schen9-DESK>
In-Reply-To: <1363987761.8972.60.camel@schen9-DESK>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.03.2013 23:29, Tim Chen wrote:
> We added glue code and config options to create crypto
> module that uses SSE/AVX/AVX2 optimized SHA256 x86_64 assembly routines.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

..snip..

> diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
> new file mode 100644
> index 0000000..5876a19
> --- /dev/null
> +++ b/arch/x86/crypto/sha256_ssse3_glue.c

..snip..

> +static int __init sha256_ssse3_mod_init(void)
> +{
> +	/* test for SSE3 first */
> +	if (cpu_has_xmm3)
> +		sha256_transform_asm = sha256_transform_ssse3;
> +

This causes OOPS on my computer. Maybe use 'cpu_has_ssse3' instead?

-Jussi

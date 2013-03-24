Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3CXM0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 08:26:37 -0400
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:59755 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3CXM0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 08:26:34 -0400
Message-ID: <514EF0F6.4080604@iki.fi>
Date: Sun, 24 Mar 2013 14:26:30 +0200
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
Subject: Re: [PATCH 03/11] Optimized sha256 x86_64 assembly routine using
 Supplemental SSE3 instructions.
References: <cover.1363961999.git.tim.c.chen@linux.intel.com> <1363987750.8972.57.camel@schen9-DESK>
In-Reply-To: <1363987750.8972.57.camel@schen9-DESK>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.03.2013 23:29, Tim Chen wrote:
> Provides SHA256 x86_64 assembly routine optimized with SSSE3 instructions.
> Speedup of 40% or more has been measured over the generic implementation.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  arch/x86/crypto/sha256-ssse3-asm.S | 504 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 504 insertions(+)
>  create mode 100644 arch/x86/crypto/sha256-ssse3-asm.S
> 
> diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S

..snip..

> +
> +########################################################################
> +## void sha256_transform_ssse3(void *input_data, UINT32 digest[8], UINT64 num_blks)
> +## arg 1 : pointer to input data
> +## arg 2 : pointer to digest
> +## arg 3 : Num blocks
> +########################################################################
> +.text
> +.global sha256_transform_ssse3
> +.align 32
> +sha256_transform_ssse3:

Maybe use ENRTY/ENDPROC macros for exporting functions from assembly?

-Jussi


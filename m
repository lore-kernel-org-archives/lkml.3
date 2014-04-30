Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaD3E5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:57:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45512 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbaD3E5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:57:43 -0400
Message-ID: <536082B3.5010208@zytor.com>
Date: Tue, 29 Apr 2014 21:57:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/7] x86: Make old K8 swapgs workaround conditional
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org> <1398723161-21968-6-git-send-email-andi@firstfloor.org>
In-Reply-To: <1398723161-21968-6-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 03:12 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Every gs selector/index reload always paid an extra MFENCE
> between the two SWAPGS. This was to work around an old
> bug in early K8 steppings.  All other CPUs don't need the extra
> mfence. Patch the extra MFENCE only in for K8.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/cpufeature.h |  1 +
>  arch/x86/kernel/cpu/amd.c         |  3 +++
>  arch/x86/kernel/entry_64.S        | 10 +++++++++-
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 89270b4..eb4bb46 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -102,6 +102,7 @@
>  #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
>  #define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU restore */
>  #define X86_FEATURE_NONSTOP_TSC_S3 (3*32+30) /* TSC doesn't stop in S3 state */
> +#define X86_FEATURE_SWAPGS_MFENCE (3*32+31) /* SWAPGS may need MFENCE */
>  

Nitpick: should be an X86_BUG_ instead.

	-hpa



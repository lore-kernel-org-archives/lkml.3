Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab3LJPaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:30:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37207 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3LJPaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:30:24 -0500
Date: Tue, 10 Dec 2013 10:30:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86, microcode: Do Intel microcode revision check
 signed
Message-ID: <20131210153000.GA3804@phenom.dumpdata.com>
References: <1386363843-32530-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386363843-32530-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 01:04:02PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The Intel SDM Vol 3 9.11.1 Microcode update states that
> the update revision field is signed. However we do the comparison
> unsigned, as the comparison gets promoted.
> 
> Use a cast to really do a signed comparison of the microcode
> revision.

Why not just update the struct?
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/microcode_intel_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/microcode_intel_lib.c b/arch/x86/kernel/microcode_intel_lib.c
> index ce69320..68503d1 100644
> --- a/arch/x86/kernel/microcode_intel_lib.c
> +++ b/arch/x86/kernel/microcode_intel_lib.c
> @@ -41,7 +41,7 @@ update_match_cpu(unsigned int csig, unsigned int cpf,
>  int
>  update_match_revision(struct microcode_header_intel *mc_header, int rev)
>  {
> -	return (mc_header->rev <= rev) ? 0 : 1;
> +	return ((int)mc_header->rev <= rev) ? 0 : 1;
>  }
>  
>  int microcode_sanity_check(void *mc, int print_err)
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3FZTIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:08:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56872 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab3FZTIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:08:49 -0400
Date: Wed, 26 Jun 2013 21:08:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86/mce: Update MCE severity condition check
Message-ID: <20130626190845.GK20274@pd.tnic>
References: <20130626091808.GA18468@gchen.bj.intel.com>
 <0134840@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0134840@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 05:16:12AM -0400, Luck, Tony wrote:
> From: Chen Gong <gong.chen@linux.intel.com>
> 
> Update some SRAR severity conditions check to make it clearer
> according to latest Intel SDM Vol 3B (June 2013), table 15-20.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> 
> Chen Gong wrote:
> > If this patch is OK, would you please help to update it when merging
> > it? Thanks very much
> 
> This is what I plan to apply.
> 1. Changed "user land" to "in a user process" (2 places) per Boris comment
> 2. Changed "non-affected" to "unaffected" per Naveen comment
> 
> Anyone wants to jump on the "Acked-by" bandwagon - speak now.
> 
> -Tony
> 
>  arch/x86/kernel/cpu/mcheck/mce-severity.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> index beb1f16..e2703520 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -110,22 +110,17 @@ static struct severity {
>  	/* known AR MCACODs: */
>  #ifdef	CONFIG_MEMORY_FAILURE
>  	MCESEV(
> -		KEEP, "HT thread notices Action required: data load error",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
> -		MCGMASK(MCG_STATUS_EIPV, 0)
> +		KEEP, "Action required but unaffected thread is continuable",
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR),

Why did we lose MCACOD_DATA from the MASK above? Was this intentional?

> +		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)

This change I can understand as restart IP is valid for thread is
continuable.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

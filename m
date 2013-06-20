Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab3FTJmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:42:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48771 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab3FTJmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:42:01 -0400
Date: Thu, 20 Jun 2013 11:41:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/MCE: Update MCE severity condition check
Message-ID: <20130620094152.GJ32694@pd.tnic>
References: <1371719773-27572-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1371719773-27572-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 05:16:12AM -0400, Chen Gong wrote:
> Update some SRAR severity conditions check to make it clearer,
> according to latest Intel SDM Vol 3(June 2013), table 15-20.
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce-severity.c |   15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> index beb1f16..1fa12ea 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -110,22 +110,17 @@ static struct severity {
>  	/* known AR MCACODs: */
>  #ifdef	CONFIG_MEMORY_FAILURE
>  	MCESEV(
> -		KEEP, "HT thread notices Action required: data load error",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
> -		MCGMASK(MCG_STATUS_EIPV, 0)
> +		KEEP, "Action required but non-affected thread is continuable",
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR),
> +		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
>  		),
>  	MCESEV(
> -		AR, "Action required: data load error",
> +		AR, "Action required: data load error on user land",

You mean "data load error in a user process"?

>  		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
>  		USER
>  		),
>  	MCESEV(
> -		KEEP, "HT thread notices Action required: instruction fetch error",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
> -		MCGMASK(MCG_STATUS_EIPV, 0)
> -		),
> -	MCESEV(
> -		AR, "Action required: instruction fetch error",
> +		AR, "Action required: instruction fetch error on user land",

ditto?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

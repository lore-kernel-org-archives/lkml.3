Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3F0Izn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:55:43 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42489 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab3F0Izk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:55:40 -0400
Message-ID: <51CBFE03.80603@linux.vnet.ibm.com>
Date: Thu, 27 Jun 2013 14:25:31 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH] x86/mce: Update MCE severity condition check
References: <0134840@agluck-desk.sc.intel.com>
In-Reply-To: <0134840@agluck-desk.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062708-7014-0000-0000-0000033CDEAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 02:46 PM, Luck, Tony wrote:
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
>> If this patch is OK, would you please help to update it when merging
>> it? Thanks very much
>
> This is what I plan to apply.
> 1. Changed "user land" to "in a user process" (2 places) per Boris comment
> 2. Changed "non-affected" to "unaffected" per Naveen comment
>
> Anyone wants to jump on the "Acked-by" bandwagon - speak now.

Yep - looks fine to me.
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

Thanks,
Naveen

>
> -Tony
>
>   arch/x86/kernel/cpu/mcheck/mce-severity.c | 15 +++++----------
>   1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> index beb1f16..e2703520 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -110,22 +110,17 @@ static struct severity {
>   	/* known AR MCACODs: */
>   #ifdef	CONFIG_MEMORY_FAILURE
>   	MCESEV(
> -		KEEP, "HT thread notices Action required: data load error",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
> -		MCGMASK(MCG_STATUS_EIPV, 0)
> +		KEEP, "Action required but unaffected thread is continuable",
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR),
> +		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
>   		),
>   	MCESEV(
> -		AR, "Action required: data load error",
> +		AR, "Action required: data load error in a user process",
>   		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
>   		USER
>   		),
>   	MCESEV(
> -		KEEP, "HT thread notices Action required: instruction fetch error",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
> -		MCGMASK(MCG_STATUS_EIPV, 0)
> -		),
> -	MCESEV(
> -		AR, "Action required: instruction fetch error",
> +		AR, "Action required: instruction fetch error in a user process",
>   		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
>   		USER
>   		),
>


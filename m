Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab3FYGdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:33:14 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37582 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3FYGdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:33:13 -0400
Date: Tue, 25 Jun 2013 12:02:57 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/MCE: Update MCE severity condition check
Message-ID: <20130625063257.GA2274@naverao1-tp.in.ibm.com>
References: <1371719773-27572-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371719773-27572-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062506-2000-0000-0000-00000CA0433E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/06/20 05:16AM, Chen Gong wrote:
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

The SDM talks about "non-affected" logical processors, but perhaps we
can call this an "unaffected" thread?

- Naveen


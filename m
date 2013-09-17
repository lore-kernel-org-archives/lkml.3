Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab3IQIfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:35:36 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:55827
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab3IQIfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:35:34 -0400
X-IronPort-AV: E=Sophos;i="4.90,921,1371074400"; 
   d="scan'208";a="27103041"
Date: Tue, 17 Sep 2013 10:35:26 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Shalin Mehta <shalinmehta85@gmail.com>
cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: PHSModule.c: Matching the function definition
 with function declaration
In-Reply-To: <1379401962-10208-1-git-send-email-shalinmehta85@gmail.com>
Message-ID: <alpine.DEB.2.02.1309171035000.2252@hadrien>
References: <1379401962-10208-1-git-send-email-shalinmehta85@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013, Shalin Mehta wrote:

> From: Shalin Mehta <shalinmehta85@gmail.com>
>
> NOTE: Sending it again. I got mail delivery failure due to typo in emai ID gregkh@linuxfoundation.org

I think that such a comment should go below the ---, since it doesn't have
to be preserved in git.

julia

>
>
> The function implementations of the PHSModule didn't match with the declaration. The functions are static
> in the declaration but in the implemntation they are non-static
>
> Signed-off-by: Shalin Mehta <shalinmehta85@gmail.com>
> ---
>  drivers/staging/bcm/PHSModule.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSModule.c
> index af5d22f..56c5bee 100644
> --- a/drivers/staging/bcm/PHSModule.c
> +++ b/drivers/staging/bcm/PHSModule.c
> @@ -596,7 +596,7 @@ ULONG PhsDeleteSFRules(IN void *pvContext, IN B_UINT16 uiVcid)
>   * 0 if successful,
>   * >0 Error.
>   */
> -ULONG PhsCompress(IN void *pvContext,
> +static ULONG PhsCompress(IN void *pvContext,
>  		IN B_UINT16 uiVcid,
>  		IN B_UINT16 uiClsId,
>  		IN void *pvInputBuffer,
> @@ -677,7 +677,7 @@ ULONG PhsCompress(IN void *pvContext,
>   * 0 if successful,
>   * >0 Error.
>   */
> -ULONG PhsDeCompress(IN void *pvContext,
> +static ULONG PhsDeCompress(IN void *pvContext,
>  		IN B_UINT16 uiVcid,
>  		IN void *pvInputBuffer,
>  		OUT void *pvOutputBuffer,
> @@ -829,7 +829,7 @@ UINT GetServiceFlowEntry(IN struct bcm_phs_table *psServiceFlowTable,
>  	return PHS_INVALID_TABLE_INDEX;
>  }
>
> -UINT GetClassifierEntry(IN struct bcm_phs_classifier_table *pstClassifierTable,
> +static UINT GetClassifierEntry(IN struct bcm_phs_classifier_table *pstClassifierTable,
>  			IN B_UINT32 uiClsid, enum bcm_phs_classifier_context eClsContext,
>  			OUT struct bcm_phs_classifier_entry **ppstClassifierEntry)
>  {
> @@ -880,7 +880,7 @@ static UINT GetPhsRuleEntry(IN struct bcm_phs_classifier_table *pstClassifierTab
>  	return PHS_INVALID_TABLE_INDEX;
>  }
>
> -UINT CreateSFToClassifierRuleMapping(IN B_UINT16 uiVcid, IN B_UINT16  uiClsId,
> +static UINT CreateSFToClassifierRuleMapping(IN B_UINT16 uiVcid, IN B_UINT16  uiClsId,
>  				IN struct bcm_phs_table *psServiceFlowTable,
>  				struct bcm_phs_rule *psPhsRule,
>  				B_UINT8 u8AssociatedPHSI)
> @@ -913,7 +913,7 @@ UINT CreateSFToClassifierRuleMapping(IN B_UINT16 uiVcid, IN B_UINT16  uiClsId,
>  	return uiStatus;
>  }
>
> -UINT CreateClassiferToPHSRuleMapping(IN B_UINT16 uiVcid,
> +static UINT CreateClassiferToPHSRuleMapping(IN B_UINT16 uiVcid,
>  				IN B_UINT16 uiClsId,
>  				IN struct bcm_phs_entry *pstServiceFlowEntry,
>  				struct bcm_phs_rule *psPhsRule,
> @@ -1239,7 +1239,7 @@ void DumpPhsRules(struct bcm_phs_extension *pDeviceExtension)
>   *			header.
>   *	0	-If PHS rule is NULL.If PHSI is 0 indicateing packet as uncompressed.
>   */
> -int phs_decompress(unsigned char *in_buf,
> +static int phs_decompress(unsigned char *in_buf,
>  		unsigned char *out_buf,
>  		struct bcm_phs_rule *decomp_phs_rules,
>  		UINT *header_size)
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

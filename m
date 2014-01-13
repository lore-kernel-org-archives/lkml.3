Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaAMIZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:25:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48093 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaAMIZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:25:10 -0500
Date: Mon, 13 Jan 2014 11:21:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        peter.p.waskiewicz.jr@intel.com, tao.peng@emc.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging: lustre: Use of fls to find last set bit
Message-ID: <20140113082124.GC7444@mwanda>
References: <1389468763-25662-1-git-send-email-monamagarwal123@gmail.com>
 <1389471351-31782-1-git-send-email-monamagarwal123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389471351-31782-1-git-send-email-monamagarwal123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 01:45:51AM +0530, Monam Agarwal wrote:
> This introduces fls in lustre/ldlm/ldlm_extent.c
> to find the last set bit.
> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
> ---
> Changes since v1:
> * Incorrect commit message
> * Use of fls function
> Changes since v2:
> * Removal of extra variable
> 
>  drivers/staging/lustre/lustre/ldlm/ldlm_extent.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
> index ac5d66a..a4f382d 100644
> --- a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
> +++ b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
> @@ -153,7 +153,7 @@ static inline int lock_mode_to_index(ldlm_mode_t mode)
>  
>  	LASSERT(mode != 0);
>  	LASSERT(IS_PO2(mode));
> -	for (index = -1; mode; index++, mode >>= 1) ;
> +	index = fls(mode)-1;

Put spaces around math operations.  Just cut and paste what Joe wrote.

regards,
dan carpenter


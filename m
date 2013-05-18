Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3EROrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 10:47:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:56329 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab3EROrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 10:47:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,700,1363158000"; 
   d="scan'208";a="315795791"
Date: Sat, 18 May 2013 07:47:09 -0700
From: Jon Mason <jon.mason@intel.com>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.9-stable] ntb: off by one sanity checks
Message-ID: <20130518144709.GA29066@jonmason-lab>
References: <1368844538-3841-1-git-send-email-jhbird.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368844538-3841-1-git-send-email-jhbird.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 18, 2013 at 11:35:38AM +0900, Jonghwan Choi wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

Yes, please do.  I'll respond to each of the patch series, but please
apply them all.  Also, one patch was omitted from these, titled 
NTB: variable dereferenced before check

Please include that patch in 3.9 stable as well.

Thank you for doing this.

Thanks,
Jon

> 
> ------------------
> 
> From: "Dan Carpenter <dan.carpenter@oracle.com>"
> 
> commit ad3e2751e7c546ae678be1f8d86e898506b42cef upstream
> 
> These tests are off by one.  If "mw" is equal to NTB_NUM_MW then we
> would go beyond the end of the ndev->mw[] array.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/ntb/ntb_hw.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index f802e7c..195cc51 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -345,7 +345,7 @@ int ntb_read_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 *val)
>   */
>  void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
>  {
> -	if (mw > NTB_NUM_MW)
> +	if (mw >= NTB_NUM_MW)
>  		return NULL;
>  
>  	return ndev->mw[mw].vbase;
> @@ -362,7 +362,7 @@ void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
>   */
>  resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
>  {
> -	if (mw > NTB_NUM_MW)
> +	if (mw >= NTB_NUM_MW)
>  		return 0;
>  
>  	return ndev->mw[mw].bar_sz;
> @@ -380,7 +380,7 @@ resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
>   */
>  void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr)
>  {
> -	if (mw > NTB_NUM_MW)
> +	if (mw >= NTB_NUM_MW)
>  		return;
>  
>  	dev_dbg(&ndev->pdev->dev, "Writing addr %Lx to BAR %d\n", addr,
> -- 
> 1.8.1.2
> 

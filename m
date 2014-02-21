Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaBUXNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:13:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:3841 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaBUXNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:13:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,521,1389772800"; 
   d="scan'208";a="485741750"
Date: Fri, 21 Feb 2014 16:13:01 -0700
From: Jon Mason <jon.mason@intel.com>
To: Roland Dreier <roland@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NTB: Fix typo in setting one translation register
Message-ID: <20140221231300.GA3112@jonmason-lab>
References: <1392998841-17728-1-git-send-email-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392998841-17728-1-git-send-email-roland@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 08:07:21AM -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> In the code for Xeon devices in back-to-back mode with xeon_errata_workaround
> disabled, the downstream device puts the wrong value in SNB_B2B_XLAT_OFFSETL
> (SNB_MBAR01_DSD_ADDR vs. SNB_MBAR01_USD_ADDR).
> 
> This was spotted while reading code, since the typo has no practical effect,
> at least for now: the low 32 bits of both constants are actually identical
> anyway.  However, it's clearer and safer to use the right name.

Good catch.  Applied.

> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/ntb/ntb_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index 170e8e60cdb7..2774d356b689 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -785,7 +785,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
>  				/* B2B_XLAT_OFFSET is a 64bit register, but can
>  				 * only take 32bit writes
>  				 */
> -				writel(SNB_MBAR01_DSD_ADDR & 0xffffffff,
> +				writel(SNB_MBAR01_USD_ADDR & 0xffffffff,
>  				       ndev->reg_base + SNB_B2B_XLAT_OFFSETL);
>  				writel(SNB_MBAR01_USD_ADDR >> 32,
>  				       ndev->reg_base + SNB_B2B_XLAT_OFFSETU);
> -- 
> 1.9.0
> 

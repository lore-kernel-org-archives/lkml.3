Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3KTIVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:21:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38149 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:21:44 -0500
Date: Wed, 20 Nov 2013 11:17:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky_ching@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, devel@linuxdriverproject.org
Subject: Re: [PATCH 2/2] mmc: rtsx: modify phase searching method for tunning
Message-ID: <20131120081758.GX5302@mwanda>
References: <cover.1384858553.git.micky_ching@realsil.com.cn>
 <38cd1d9d7f10f6a65b4dc608f310ac3818da827f.1384858553.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38cd1d9d7f10f6a65b4dc608f310ac3818da827f.1384858553.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 07:10:35PM +0800, micky_ching@realsil.com.cn wrote:
> -static u8 sd_search_final_phase(struct realtek_pci_sdmmc *host, u32 phase_map)
> +static inline u32 sd_get_phase_point(u32 phase_map, unsigned int idx)
>  {
> -	struct timing_phase_path path[MAX_PHASE + 1];
> -	int i, j, cont_path_cnt;
> -	int new_block, max_len, final_path_idx;
> -	u8 final_phase = 0xFF;
> +	idx &= MAX_PHASE;
> +	return phase_map & (1 << idx);
> +}
> +

This function is confusing....

MAX_PHASE is a terrible name.  It's in a global header but it doesn't
have a prefix.  It should be #define RTS_MAX_PHASE.  It's weird that we
are using it both as a number and as bit mask.  It's weird that we
always add a "+ 1" to MAX_PHASE.  It means the name is chosen poorly.
Maybe it should be:

#define RTS_MAX_PHASE  32
#define RTS_PHASE_MASK 0x1f

So this function takes a phase_map and an index and it wraps the index
by masking away the top bits then it tests to see if the wrapped index
bit is set?  The wrapping is very strange.

The name of the function is sd_get_phase_point() but we only test to
see if it returns zero.  The name of the function is not helpful.
"sd" is a generic prefix.
"get" is misleading because we don't "get" anything it only returns zero
on success?
"phase_point" might be helpful but I don't know what a phase_point is.
Add a comment about that maybe.

regards,
dan carpenter


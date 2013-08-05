Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3HECtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:49:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:37217 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab3HECtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:49:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,815,1367996400"; 
   d="scan'208";a="277659791"
Message-ID: <51FF127D.4030004@intel.com>
Date: Mon, 05 Aug 2013 10:48:29 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <h.peter.anvin@intel.com>
CC: Ilari Stenroth <ilari.stenroth@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/cpu/intel.c needs an update for Haswell?
References: <kt91u2$jhs$1@ger.gmane.org> <20130730193530.GB23299@pd.tnic> <kt951r$m5m$1@ger.gmane.org> <20130730195402.GD23299@pd.tnic> <51FA220B.5070307@intel.com>
In-Reply-To: <51FA220B.5070307@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 04:53 PM, Alex Shi wrote:
> From 1322ea9e17ad4d9e49e2d93cfc04805368e28273 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Thu, 1 Aug 2013 16:30:23 +0800
> Subject: [PATCH 2/2] tlb/tlb_flushall_shift: add haswell tlb_flush_shift
> 
> Tested on i5 4350U with munmap case, https://lkml.org/lkml/2012/5/17/59
> The best performance is tlb_flush_shift = 1.
> The balance point is 256 entries.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>


Any comments on this, Peter? :)
> ---
>  arch/x86/kernel/cpu/intel.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 9a4bc51..ac9b83a 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -627,6 +627,7 @@ static void intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
>  		tlb_flushall_shift = 5;
>  		break;
>  	case 0x63a: /* Ivybridge */
> +	case 0x645: /* Haswell */
>  		tlb_flushall_shift = 1;
>  		break;
>  	case 0x63e: /* Ivybridge EP */


-- 
Thanks
    Alex

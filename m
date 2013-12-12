Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3LLNpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:45:30 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48736 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3LLNp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:45:29 -0500
Message-ID: <52A9BDF4.2040101@linaro.org>
Date: Thu, 12 Dec 2013 21:45:24 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86: mm: Change tlb_flushall_shift for IvyBridge
References: <1386849309-22584-1-git-send-email-mgorman@suse.de> <1386849309-22584-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1386849309-22584-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 07:55 PM, Mel Gorman wrote:
> There was a large performance regression that was bisected to commit 611ae8e3
> (x86/tlb: enable tlb flush range support for x86). This patch simply changes
> the default balance point between a local and global flush for IvyBridge.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

agree to be more conservative.

Reviewed-by: Alex Shi <alex.shi@linro.org>
> ---
>  arch/x86/kernel/cpu/intel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index dc1ec0d..2d93753 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -627,7 +627,7 @@ static void intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
>  		tlb_flushall_shift = 5;
>  		break;
>  	case 0x63a: /* Ivybridge */
> -		tlb_flushall_shift = 1;
> +		tlb_flushall_shift = 2;
>  		break;
>  	default:
>  		tlb_flushall_shift = 6;
> 


-- 
Thanks
    Alex

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3KSKmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:42:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3KSKmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:42:05 -0500
Date: Tue, 19 Nov 2013 11:42:03 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Expose sysctls for enabling slab/file_cache interleaving
Message-ID: <20131119104203.GB18872@dhcp22.suse.cz>
References: <1384822222-28795-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384822222-28795-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-11-13 16:50:22, Andi Kleen wrote:
[...]
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index cc1b01c..10966f5 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -72,12 +72,14 @@ extern int cpuset_slab_spread_node(void);
>  
>  static inline int cpuset_do_page_mem_spread(void)
>  {
> -	return current->flags & PF_SPREAD_PAGE;
> +	return (current->flags & PF_SPREAD_PAGE) ||
> +		sysctl_spread_file_cache;
>  }

But this might break applications that explicitly opt out from
spreading.

>  
>  static inline int cpuset_do_slab_mem_spread(void)
>  {
> -	return current->flags & PF_SPREAD_SLAB;
> +	return (current->flags & PF_SPREAD_SLAB) || 
> +		sysctl_spread_slab;
>  }
>  
>  extern int current_cpuset_is_being_rebound(void);
[...]
-- 
Michal Hocko
SUSE Labs

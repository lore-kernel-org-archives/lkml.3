Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936045Ab3BONFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:05:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936032Ab3BONFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:05:38 -0500
Date: Fri, 15 Feb 2013 14:05:36 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Glauber Costa <glommer@parallels.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] ia64: rename cache_show to topology_cache_show
Message-ID: <20130215130536.GB31037@dhcp22.suse.cz>
References: <511e236a.o0ibbB2U8xMoURgd%fengguang.wu@intel.com>
 <1360931904-5720-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360931904-5720-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scratch that. I should have checked origin/master which already fixed
that by 4fafc8c21487f6b5259d462e9bee98661a02390d

Sorry for the noise.

On Fri 15-02-13 13:38:24, Michal Hocko wrote:
> Fenguang Wu has reported the following compile time issue
> arch/ia64/kernel/topology.c:278:16: error: conflicting types for 'cache_show'
> include/linux/slab.h:224:5: note: previous declaration of 'cache_show' was here
> 
> which has been introduced by 749c5415 (memcg: aggregate memcg cache
> values in slabinfo). Let's rename ia64 local function to prevent from
> the name conflict.
> 
> Reported-by: Fenguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  arch/ia64/kernel/topology.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
> index c64460b..d9e2152 100644
> --- a/arch/ia64/kernel/topology.c
> +++ b/arch/ia64/kernel/topology.c
> @@ -275,7 +275,8 @@ static struct attribute * cache_default_attrs[] = {
>  #define to_object(k) container_of(k, struct cache_info, kobj)
>  #define to_attr(a) container_of(a, struct cache_attr, attr)
>  
> -static ssize_t cache_show(struct kobject * kobj, struct attribute * attr, char * buf)
> +static ssize_t topology_cache_show(struct kobject * kobj,
> +		struct attribute * attr, char * buf)
>  {
>  	struct cache_attr *fattr = to_attr(attr);
>  	struct cache_info *this_leaf = to_object(kobj);
> @@ -286,7 +287,7 @@ static ssize_t cache_show(struct kobject * kobj, struct attribute * attr, char *
>  }
>  
>  static const struct sysfs_ops cache_sysfs_ops = {
> -	.show   = cache_show
> +	.show   = topology_cache_show
>  };
>  
>  static struct kobj_type cache_ktype = {
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab3FMCi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:38:28 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:23183 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab3FMCi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:38:26 -0400
Message-ID: <51B93096.5060702@huawei.com>
Date: Thu, 13 Jun 2013 10:38:14 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <koverstreet@google.com>, <linux-kernel@vger.kernel.org>,
        <cl@linux-foundation.org>
Subject: Re: [PATCH 05/11] cgroup: clean up css_[try]get() and css_put()
References: <1371070996-20613-1-git-send-email-tj@kernel.org> <1371070996-20613-6-git-send-email-tj@kernel.org>
In-Reply-To: <1371070996-20613-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/13 5:03, Tejun Heo wrote:
> * __css_get() isn't used by anyone.  Fold it into css_get().
> 
> * Add proper function comments to all css reference functions.
> 
> This patch is purely cosmetic.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  include/linux/cgroup.h | 48 ++++++++++++++++++++++++------------------------
>  1 file changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 0e32855..7b16882 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -94,33 +94,31 @@ enum {
>  	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
>  };
>  
> -/* Caller must verify that the css is not for root cgroup */
> -static inline void __css_get(struct cgroup_subsys_state *css, int count)
> -{
> -	atomic_add(count, &css->refcnt);
> -}
> -
> -/*
> - * Call css_get() to hold a reference on the css; it can be used
> - * for a reference obtained via:
> - * - an existing ref-counted reference to the css
> - * - task->cgroups for a locked task
> +/**
> + * css_get - obtain a reference on the specified css
> + * @css: taget css

s/taget/target

> + *
> + * The caller must already have a reference.
>   */
> -
>  static inline void css_get(struct cgroup_subsys_state *css)
>  {
>  	/* We don't need to reference count the root state */
>  	if (!(css->flags & CSS_ROOT))
> -		__css_get(css, 1);
> +		atomic_inc(&css->refcnt);
>  }
>  


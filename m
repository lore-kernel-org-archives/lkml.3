Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaCBJGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 04:06:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:59618 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbaCBJGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 04:06:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,571,1389772800"; 
   d="scan'208";a="490753358"
Message-ID: <5312F47B.8080603@linux.intel.com>
Date: Sun, 02 Mar 2014 17:06:03 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: shuox.liu@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
CC: tony.luck@intel.com, keescook@chromium.org, ccross@android.com,
        anton@enomsg.org
Subject: Re: [PATCH] pstore: skip zero size persistent ram buffer in traverse
References: <1393569501-14952-1-git-send-email-shuox.liu@intel.com>
In-Reply-To: <1393569501-14952-1-git-send-email-shuox.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/28 14:38, shuox.liu@intel.com wrote:
> From: Liu ShuoX <shuox.liu@intel.com>
>
> In ramoops_pstore_read, a valid prz pointer with zero size buffer will
> break traverse of all persistent ram buffers. The latter buffer might
> be lost.

Andrew,

Would you like to merge it to your testing tree?
pstore is a very important feature for debugging hard issues on
Android mobiles.

Yanmin

>
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> ---
>   fs/pstore/ram.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index a5d0cab..929ea55 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -119,12 +119,12 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
>   
>   	prz = przs[i];
>   
> -	if (update) {
> -		/* Update old/shadowed buffer. */
> +	/* Update old/shadowed buffer. */
> +	if (update)
>   		persistent_ram_save_old(prz);
> -		if (!persistent_ram_old_size(prz))
> -			return NULL;
> -	}
> +
> +	if (!persistent_ram_old_size(prz))
> +		return NULL;
>   
>   	*typep = type;
>   	*id = i;


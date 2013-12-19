Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3LSBPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:15:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:36052 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab3LSBPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:15:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,510,1384329600"; 
   d="scan'208";a="446687799"
Date: Thu, 19 Dec 2013 09:15:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: davem@davemloft.net, ffusco@redhat.com, kbuild-all@01.org,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [net-next/master PATCH] lib: fix compile warning in hashlib_init
Message-ID: <20131219011506.GA27326@localhost>
References: <1387415314-21786-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387415314-21786-1-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC the list.

On Thu, Dec 19, 2013 at 09:08:34AM +0800, Wanlong Gao wrote:
> /git/linux/lib/hash.c: In function 'hashlib_init':
> /git/linux/lib/hash.c:35:2: warning: passing argument 1 of 'setup_arch_fast_hash' from incompatible pointer type [enabled by default]
> /git/linux/include/asm-generic/hash.h:5:20: note: expected 'struct arch_hash_ops *' but argument is of type 'struct fast_hash_ops *'
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  include/asm-generic/hash.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/hash.h b/include/asm-generic/hash.h
> index 05cb342..b631284 100644
> --- a/include/asm-generic/hash.h
> +++ b/include/asm-generic/hash.h
> @@ -1,8 +1,8 @@
>  #ifndef __ASM_GENERIC_HASH_H
>  #define __ASM_GENERIC_HASH_H
>  
> -struct arch_hash_ops;
> -static inline void setup_arch_fast_hash(struct arch_hash_ops *ops)
> +struct fast_hash_ops;
> +static inline void setup_arch_fast_hash(struct fast_hash_ops *ops)
>  {
>  }
>  
> -- 
> 1.8.5.2.192.g7794a68

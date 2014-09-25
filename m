Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaIYRhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:37:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:48949 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaIYRhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:37:47 -0400
Message-ID: <542452E5.8040806@infradead.org>
Date: Thu, 25 Sep 2014 10:37:41 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org
CC: linux-doc@vger.kernel.org, sudeep.dutt@intel.com, nikhil.rao@intel.com,
        ashutosh.dixit@intel.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] tools: add more endian.h macros
References: <1411512653-17093-1-git-send-email-pefoley2@pefoley.com>
In-Reply-To: <1411512653-17093-1-git-send-email-pefoley2@pefoley.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/14 15:50, Peter Foley wrote:
> Add some more macros to tools/endian.h to allow mpssd to be compiled
> against glibc < 2.9.
> 
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>

Applied.  Thanks.

> Cc: rdunlap@infradead.org
> Cc: linux-doc@vger.kernel.org
> Cc: sudeep.dutt@intel.com
> Cc: nikhil.rao@intel.com
> Cc: ashutosh.dixit@intel.com
> Cc: akpm@linux-foundation.org
> Cc: gregkh@linuxfoundation.org
> ---
>  tools/include/tools/endian.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/tools/include/tools/endian.h b/tools/include/tools/endian.h
> index 5d42e20..8001194 100644
> --- a/tools/include/tools/endian.h
> +++ b/tools/include/tools/endian.h
> @@ -15,6 +15,18 @@
>  #define htole64(x) (x)
>  #endif
>  
> +#ifndef le16toh
> +#define le16toh(x) (x)
> +#endif
> +
> +#ifndef le32toh
> +#define le32toh(x) (x)
> +#endif
> +
> +#ifndef le64toh
> +#define le64toh(x) (x)
> +#endif
> +
>  #else /* __BYTE_ORDER */
>  
>  #ifndef htole16
> @@ -27,6 +39,18 @@
>  #define htole64(x) __bswap_64(x)
>  #endif
>  
> +#ifndef le16toh
> +#define le16toh(x) __bswap_16(x)
> +#endif
> +
> +#ifndef le32toh
> +#define le32toh(x) __bswap_32(x)
> +#endif
> +
> +#ifndef le64toh
> +#define le64toh(x) __bswap_64(x)
> +#endif
> +
>  #endif
>  
>  #endif /* _TOOLS_ENDIAN_H */
> 


-- 
~Randy

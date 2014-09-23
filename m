Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbaIWVqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:46:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:35856 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbaIWVqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:46:17 -0400
Message-ID: <5421EA22.6000206@infradead.org>
Date: Tue, 23 Sep 2014 14:46:10 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ashutosh Dixit <ashutosh.dixit@intel.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Foley <pefoley2@pefoley.com>
CC: Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH linux-next] Documentation: mic: mpssd: Disable mpssd builds
 for kernels < 3.13
References: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
In-Reply-To: <c6aff784285e77771ad4edd3d451d95529bfb17d.1411496575.git.ashutosh.dixit@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/14 14:55, Ashutosh Dixit wrote:
> mpssd depends on headers available in kernels >= 3.13. Therefore
> disable the build for kernels < 3.13. For kernels < 3.13, to avoid the
> appearance of a build break simply print an error message and exit.

Why is this needed?  This file won't be built in any automated build
in v3.13 or any kernel until v3.17 at the earliest?


> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Peter Foley <pefoley2@pefoley.com>
> Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
> Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
> Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> ---
>  Documentation/mic/mpssd/mpssd.c | 15 +++++++++++++++
>  Documentation/mic/mpssd/sysfs.c |  5 +++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
> index 3c5c379..2cc48cc 100644
> --- a/Documentation/mic/mpssd/mpssd.c
> +++ b/Documentation/mic/mpssd/mpssd.c
> @@ -18,6 +18,10 @@
>   * Intel MIC User Space Tools.
>   */
>  
> +#include <linux/version.h>
> +
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3, 13, 0))
> +
>  #define _GNU_SOURCE
>  
>  #include <stdlib.h>
> @@ -1726,3 +1730,14 @@ main(int argc, char *argv[])
>  
>  	exit(0);
>  }
> +#else /* kernel version < 3.13 */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +int main(void)
> +{
> +	fprintf(stderr, "mpssd is only usable against kernels >= 3.13\n");
> +	exit(1);
> +}
> +#endif
> diff --git a/Documentation/mic/mpssd/sysfs.c b/Documentation/mic/mpssd/sysfs.c
> index 8dd3269..1e3ff75 100644
> --- a/Documentation/mic/mpssd/sysfs.c
> +++ b/Documentation/mic/mpssd/sysfs.c
> @@ -18,6 +18,10 @@
>   * Intel MIC User Space Tools.
>   */
>  
> +#include <linux/version.h>
> +
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3, 13, 0))
> +
>  #include "mpssd.h"
>  
>  #define PAGE_SIZE 4096
> @@ -100,3 +104,4 @@ done:
>  		free(oldvalue);
>  	return ret;
>  }
> +#endif
> 


-- 
~Randy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaBZHb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 02:31:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaBZHbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 02:31:53 -0500
Message-ID: <530D9862.1070108@canonical.com>
Date: Tue, 25 Feb 2014 23:31:46 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
CC: James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/8] security: apparmor: Use a more current logging style
References: <cover.1393279025.git.joe@perches.com> <ff8a7d422cfa605de40dc64c103f27ed7a76e0cf.1393279025.git.joe@perches.com>
In-Reply-To: <ff8a7d422cfa605de40dc64c103f27ed7a76e0cf.1393279025.git.joe@perches.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 01:59 PM, Joe Perches wrote:
> Convert printks to pr_<level>.
> Add pr_fmt.
> Coalesce formats.
> Remove embedded prefixes from logging.
> 

you missed one place,

--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -50,7 +50,7 @@ extern unsigned int aa_g_path_max;
 #define AA_DEBUG(fmt, args...)                                         \
        do {                                                            \
                if (aa_g_debug && printk_ratelimit())                   \
-                       printk(KERN_DEBUG "AppArmor: " fmt, ##args);    \
+                       pr_debug(fmt, ##args);                          \
        } while (0)
 
 #define AA_ERROR(fmt, args...)                                         \

other than that looks good.

> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/apparmor/apparmorfs.c       | 2 ++
>  security/apparmor/crypto.c           | 2 ++
>  security/apparmor/include/apparmor.h | 2 +-
>  security/apparmor/lib.c              | 4 +++-
>  security/apparmor/lsm.c              | 2 ++
>  security/apparmor/match.c            | 5 +++--
>  security/apparmor/policy.c           | 2 ++
>  security/apparmor/procattr.c         | 2 ++
>  8 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
> index 7db9954..d4b65cc 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -12,6 +12,8 @@
>   * License.
>   */
>  
> +#define pr_fmt(fmt) "AppArmor: " fmt
> +
>  #include <linux/ctype.h>
>  #include <linux/security.h>
>  #include <linux/vmalloc.h>
> diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
> index 532471d..9506544 100644
> --- a/security/apparmor/crypto.c
> +++ b/security/apparmor/crypto.c
> @@ -15,6 +15,8 @@
>   * it should be.
>   */
>  
> +#define pr_fmt(fmt) "AppArmor: " fmt
> +
>  #include <crypto/hash.h>
>  
>  #include "include/apparmor.h"
> diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
> index 8fb1488..3065025 100644
> --- a/security/apparmor/include/apparmor.h
> +++ b/security/apparmor/include/apparmor.h
> @@ -56,7 +56,7 @@ extern unsigned int aa_g_path_max;
>  #define AA_ERROR(fmt, args...)						\
>  	do {								\
>  		if (printk_ratelimit())					\
> -			printk(KERN_ERR "AppArmor: " fmt, ##args);	\
> +			pr_err(fmt, ##args);				\
>  	} while (0)
>  
>  /* Flag indicating whether initialization completed */
> diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
> index 6968992..432b1b6 100644
> --- a/security/apparmor/lib.c
> +++ b/security/apparmor/lib.c
> @@ -12,6 +12,8 @@
>   * License.
>   */
>  
> +#define pr_fmt(fmt) "AppArmor: " fmt
> +
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
> @@ -73,7 +75,7 @@ void aa_info_message(const char *str)
>  		aad.info = str;
>  		aa_audit_msg(AUDIT_APPARMOR_STATUS, &sa, NULL);
>  	}
> -	printk(KERN_INFO "AppArmor: %s\n", str);
> +	pr_info("%s\n", str);
>  }
>  
>  /**
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 9981000..49f0180 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -12,6 +12,8 @@
>   * License.
>   */
>  
> +#define pr_fmt(fmt) "AppArmor: " fmt
> +
>  #include <linux/security.h>
>  #include <linux/moduleparam.h>
>  #include <linux/mm.h>
> diff --git a/security/apparmor/match.c b/security/apparmor/match.c
> index 727eb42..688482a 100644
> --- a/security/apparmor/match.c
> +++ b/security/apparmor/match.c
> @@ -12,6 +12,8 @@
>   * License.
>   */
>  
> +#define pr_fmt(fmt) "AppArmor: " fmt
> +
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> @@ -140,8 +142,7 @@ static int verify_dfa(struct aa_dfa *dfa, int flags)
>  			if (DEFAULT_TABLE(dfa)[i] >= state_count)
>  				goto out;
>  			if (base_idx(BASE_TABLE(dfa)[i]) + 255 >= trans_count) {
> -				printk(KERN_ERR "AppArmor DFA next/check upper "
> -				       "bounds error\n");
> +				pr_err("DFA next/check upper bounds error\n");
>  				goto out;
>  			}
>  		}
> diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
> index 705c287..4e20c1f 100644
> --- a/security/apparmor/policy.c
> +++ b/security/apparmor/policy.c
> @@ -73,6 +73,8 @@
>   * FIXME: move profile lists to using rcu_lists
>   */
>  
> +#define pr_fmt(fmt) "AppArmor: " fmt
> +
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/string.h>
> diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
> index b125acc..c105fc5 100644
> --- a/security/apparmor/procattr.c
> +++ b/security/apparmor/procattr.c
> @@ -12,6 +12,8 @@
>   * License.
>   */
>  
> +#define pr_fmt(fmt) "AppArmor: " fmt
> +
>  #include "include/apparmor.h"
>  #include "include/context.h"
>  #include "include/policy.h"
> 


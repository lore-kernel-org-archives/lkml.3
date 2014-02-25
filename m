Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaBYC7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:59:55 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58726 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBYC7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:59:53 -0500
Message-ID: <1393297187.2001.3.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 3/8] security: integrity: Use a more current logging
 style
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        James Morris <james.l.morris@oracle.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module@vger.kernel.org
Date: Mon, 24 Feb 2014 21:59:47 -0500
In-Reply-To: <25bc41150cc3966f5c8dfcd028ad3652e19f5efa.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com>
	 <25bc41150cc3966f5c8dfcd028ad3652e19f5efa.1393279025.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022502-7164-0000-0000-00000663DEA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 13:59 -0800, Joe Perches wrote: 
> Convert printks to pr_<level>.
> Add pr_fmt.
> Remove embedded prefixes.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks Joe, both this and the keys patch look good.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

> ---
>  security/integrity/evm/evm_crypto.c   | 4 +++-
>  security/integrity/evm/evm_main.c     | 6 ++++--
>  security/integrity/evm/evm_secfs.c    | 6 ++++--
>  security/integrity/ima/ima_crypto.c   | 4 +++-
>  security/integrity/ima/ima_init.c     | 5 ++++-
>  security/integrity/ima/ima_queue.c    | 8 +++++---
>  security/integrity/ima/ima_template.c | 5 ++++-
>  7 files changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
> index 3bab89e..9bd329f 100644
> --- a/security/integrity/evm/evm_crypto.c
> +++ b/security/integrity/evm/evm_crypto.c
> @@ -13,6 +13,8 @@
>   *	 Using root's kernel master key (kmk), calculate the HMAC
>   */
> 
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/crypto.h>
>  #include <linux/xattr.h>
> @@ -221,7 +223,7 @@ int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
> 
>  	desc = init_desc(EVM_XATTR_HMAC);
>  	if (IS_ERR(desc)) {
> -		printk(KERN_INFO "init_desc failed\n");
> +		pr_info("init_desc failed\n");
>  		return PTR_ERR(desc);
>  	}
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 336b3dd..996092f 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -14,6 +14,8 @@
>   *	evm_inode_removexattr, and evm_verifyxattr
>   */
> 
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/crypto.h>
>  #include <linux/audit.h>
> @@ -432,7 +434,7 @@ static int __init init_evm(void)
> 
>  	error = evm_init_secfs();
>  	if (error < 0) {
> -		printk(KERN_INFO "EVM: Error registering secfs\n");
> +		pr_info("Error registering secfs\n");
>  		goto err;
>  	}
> 
> @@ -449,7 +451,7 @@ static int __init evm_display_config(void)
>  	char **xattrname;
> 
>  	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++)
> -		printk(KERN_INFO "EVM: %s\n", *xattrname);
> +		pr_info("%s\n", *xattrname);
>  	return 0;
>  }
> 
> diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
> index 30f670a..cf12a04 100644
> --- a/security/integrity/evm/evm_secfs.c
> +++ b/security/integrity/evm/evm_secfs.c
> @@ -13,6 +13,8 @@
>   *	- Get the key and enable EVM
>   */
> 
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/uaccess.h>
>  #include <linux/module.h>
>  #include "evm.h"
> @@ -79,9 +81,9 @@ static ssize_t evm_write_key(struct file *file, const char __user *buf,
>  	error = evm_init_key();
>  	if (!error) {
>  		evm_initialized = 1;
> -		pr_info("EVM: initialized\n");
> +		pr_info("initialized\n");
>  	} else
> -		pr_err("EVM: initialization failed\n");
> +		pr_err("initialization failed\n");
>  	return count;
>  }
> 
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index fdf60de..972df659 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -13,6 +13,8 @@
>   * 	Calculates md5/sha1 file hash, template hash, boot-aggreate hash
>   */
> 
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/file.h>
>  #include <linux/crypto.h>
> @@ -205,7 +207,7 @@ static void __init ima_pcrread(int idx, u8 *pcr)
>  		return;
> 
>  	if (tpm_pcr_read(TPM_ANY_NUM, idx, pcr) != 0)
> -		pr_err("IMA: Error Communicating to TPM chip\n");
> +		pr_err("Error Communicating to TPM chip\n");
>  }
> 
>  /*
> diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
> index 3712276..b3bc313 100644
> --- a/security/integrity/ima/ima_init.c
> +++ b/security/integrity/ima/ima_init.c
> @@ -14,6 +14,9 @@
>   * File: ima_init.c
>   *             initialization and cleanup functions
>   */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
>  #include <linux/slab.h>
> @@ -93,7 +96,7 @@ int __init ima_init(void)
>  		ima_used_chip = 1;
> 
>  	if (!ima_used_chip)
> -		pr_info("IMA: No TPM chip found, activating TPM-bypass!\n");
> +		pr_info("No TPM chip found, activating TPM-bypass!\n");
> 
>  	rc = ima_init_crypto();
>  	if (rc)
> diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
> index d85e997..91128b4 100644
> --- a/security/integrity/ima/ima_queue.c
> +++ b/security/integrity/ima/ima_queue.c
> @@ -18,6 +18,9 @@
>   *       The measurement list is append-only. No entry is
>   *       ever removed or changed during the boot-cycle.
>   */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/rculist.h>
>  #include <linux/slab.h>
> @@ -72,7 +75,7 @@ static int ima_add_digest_entry(struct ima_template_entry *entry)
> 
>  	qe = kmalloc(sizeof(*qe), GFP_KERNEL);
>  	if (qe == NULL) {
> -		pr_err("IMA: OUT OF MEMORY ERROR creating queue entry.\n");
> +		pr_err("OUT OF MEMORY ERROR creating queue entry\n");
>  		return -ENOMEM;
>  	}
>  	qe->entry = entry;
> @@ -95,8 +98,7 @@ static int ima_pcr_extend(const u8 *hash)
> 
>  	result = tpm_pcr_extend(TPM_ANY_NUM, CONFIG_IMA_MEASURE_PCR_IDX, hash);
>  	if (result != 0)
> -		pr_err("IMA: Error Communicating to TPM chip, result: %d\n",
> -		       result);
> +		pr_err("Error Communicating to TPM chip, result: %d\n", result);
>  	return result;
>  }
> 
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index 635695f..9a4a0d1 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -12,6 +12,9 @@
>   * File: ima_template.c
>   *      Helpers to manage template descriptors.
>   */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <crypto/hash_info.h>
> 
>  #include "ima.h"
> @@ -58,7 +61,7 @@ static int __init ima_template_setup(char *str)
>  	 */
>  	if (template_len == 3 && strcmp(str, IMA_TEMPLATE_IMA_NAME) == 0 &&
>  	    ima_hash_algo != HASH_ALGO_SHA1 && ima_hash_algo != HASH_ALGO_MD5) {
> -		pr_err("IMA: template does not support hash alg\n");
> +		pr_err("template does not support hash alg\n");
>  		return 1;
>  	}
> 



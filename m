Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaBXWXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:23:15 -0500
Received: from smtp103.biz.mail.ne1.yahoo.com ([98.138.207.10]:23050 "HELO
	smtp103.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752376AbaBXWXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:23:13 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zL8_l4YVM1khj2ST8LLhFv6bFnxL7G_4d7ACC0xyeGhGORQ
 lMrbUkCJGqKYkts9Jy.59a_Uekj1gfEv7ykppui39cEEDY0UrtzwgPHwbM54
 DyVcHMr22bhcx16.SFK1jbnBYPVL34gC661PWjhmsIHcDPzb6EZmYySOBDgG
 ymgZW3EjnTGDf.yEBpmeR59mkEuvsXBhAc9WjGcx45p3x1JwSGGE58jVQYKQ
 ZQ2OBZ8MWN4KSftu6L3LXqhPnyliJYjas7HbHJKfrbYg1MA3fSDetXnoDVre
 qkxka0vWZGjy1uv3Nsgrsmm3fEgMi827UrGNCgW0MpXxKalxTHyWzgC0dVgW
 T9m9ciBC0FVz22nUMPOI0RyHBeWAO3PP2ouW05AT4CsQJK28pkH0xDWL1wcE
 fGL6XvJL08RPlfAtTJGBS5UyCPFxDReKIuyi65HgtYU9APQaqaBRIhg1zBYV
 BYuAbR3sezWYpfG9u62UsI9sZcz22cacN2b3U4NJcd71f.f76mwPz1nEkK5L
 BnpeU1Q_BnCkF5mvRJdp4aKLkIIo.3cKMJdIBWjG86v3Y91sJkg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [98.138.105.25])
        by smtp103.biz.mail.ne1.yahoo.com with SMTP; 24 Feb 2014 14:16:32 -0800 PST
Message-ID: <530BC4BF.2000904@schaufler-ca.com>
Date: Mon, 24 Feb 2014 14:16:31 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
CC: James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 6/8] security: smack: Use a more current logging style
References: <cover.1393279025.git.joe@perches.com> <3b69f0961dff21133e276d5c3edee8b05c41f8c5.1393279025.git.joe@perches.com>
In-Reply-To: <3b69f0961dff21133e276d5c3edee8b05c41f8c5.1393279025.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/2014 1:59 PM, Joe Perches wrote:
> Convert printks to pr_<level>
> Add pr_fmt.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  security/smack/smack_lsm.c |  7 ++++---
>  security/smack/smackfs.c   | 25 +++++++++++--------------
>  2 files changed, 15 insertions(+), 17 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 14f52be..a273aad 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -18,6 +18,8 @@
>   *      as published by the Free Software Foundation.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +

What is pr_fmt() for?

>  #include <linux/xattr.h>
>  #include <linux/pagemap.h>
>  #include <linux/mount.h>
> @@ -2106,8 +2108,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
>  		if (sock->sk->sk_family == PF_INET) {
>  			rc = smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
>  			if (rc != 0)
> -				printk(KERN_WARNING
> -					"Smack: \"%s\" netlbl error %d.\n",
> +				pr_warn("\"%s\" netlbl error %d\n",
>  					__func__, -rc);
>  		}
>  	} else
> @@ -3916,7 +3917,7 @@ static __init int smack_init(void)
>  	if (tsp == NULL)
>  		return -ENOMEM;
>  
> -	printk(KERN_INFO "Smack:  Initializing.\n");
> +	pr_info("Initializing\n");
>  
>  	/*
>  	 * Set the security state for the initial task.
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 3198cfe..2e25220 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -16,6 +16,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/vmalloc.h>
>  #include <linux/security.h>
> @@ -698,8 +700,7 @@ static void smk_cipso_doi(void)
>  
>  	rc = netlbl_cfg_map_del(NULL, PF_INET, NULL, NULL, &nai);
>  	if (rc != 0)
> -		printk(KERN_WARNING "%s:%d remove rc = %d\n",
> -		       __func__, __LINE__, rc);
> +		pr_warn("%s:%d remove rc = %d\n", __func__, __LINE__, rc);
>  
>  	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
>  	if (doip == NULL)
> @@ -713,15 +714,13 @@ static void smk_cipso_doi(void)
>  
>  	rc = netlbl_cfg_cipsov4_add(doip, &nai);
>  	if (rc != 0) {
> -		printk(KERN_WARNING "%s:%d cipso add rc = %d\n",
> -		       __func__, __LINE__, rc);
> +		pr_warn("%s:%d cipso add rc = %d\n", __func__, __LINE__, rc);
>  		kfree(doip);
>  		return;
>  	}
>  	rc = netlbl_cfg_cipsov4_map_add(doip->doi, NULL, NULL, NULL, &nai);
>  	if (rc != 0) {
> -		printk(KERN_WARNING "%s:%d map add rc = %d\n",
> -		       __func__, __LINE__, rc);
> +		pr_warn("%s:%d map add rc = %d\n", __func__, __LINE__, rc);
>  		kfree(doip);
>  		return;
>  	}
> @@ -741,8 +740,8 @@ static void smk_unlbl_ambient(char *oldambient)
>  	if (oldambient != NULL) {
>  		rc = netlbl_cfg_map_del(oldambient, PF_INET, NULL, NULL, &nai);
>  		if (rc != 0)
> -			printk(KERN_WARNING "%s:%d remove rc = %d\n",
> -			       __func__, __LINE__, rc);
> +			pr_warn("%s:%d remove rc = %d\n",
> +				__func__, __LINE__, rc);
>  	}
>  	if (smack_net_ambient == NULL)
>  		smack_net_ambient = &smack_known_floor;
> @@ -750,8 +749,7 @@ static void smk_unlbl_ambient(char *oldambient)
>  	rc = netlbl_cfg_unlbl_map_add(smack_net_ambient->smk_known, PF_INET,
>  				      NULL, NULL, &nai);
>  	if (rc != 0)
> -		printk(KERN_WARNING "%s:%d add rc = %d\n",
> -		       __func__, __LINE__, rc);
> +		pr_warn("%s:%d add rc = %d\n", __func__, __LINE__, rc);
>  }
>  
>  /*
> @@ -2302,8 +2300,7 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files);
>  	if (rc != 0) {
> -		printk(KERN_ERR "%s failed %d while creating inodes\n",
> -			__func__, rc);
> +		pr_err("%s failed %d while creating inodes\n", __func__, rc);
>  		return rc;
>  	}
>  
> @@ -2369,13 +2366,13 @@ static int __init init_smk_fs(void)
>  
>  	err = smk_init_sysfs();
>  	if (err)
> -		printk(KERN_ERR "smackfs: sysfs mountpoint problem.\n");
> +		pr_err("smackfs: sysfs mountpoint problem\n");
>  
>  	err = register_filesystem(&smk_fs_type);
>  	if (!err) {
>  		smackfs_mount = kern_mount(&smk_fs_type);
>  		if (IS_ERR(smackfs_mount)) {
> -			printk(KERN_ERR "smackfs:  could not mount!\n");
> +			pr_err("smackfs: could not mount!\n");
>  			err = PTR_ERR(smackfs_mount);
>  			smackfs_mount = NULL;
>  		}


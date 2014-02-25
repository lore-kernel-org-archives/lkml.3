Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaBYHjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:39:36 -0500
Received: from tundra.namei.org ([65.99.196.166]:43645 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaBYHjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:39:33 -0500
Date: Tue, 25 Feb 2014 18:47:17 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 6/8] security: smack: Use a more current logging style
In-Reply-To: <530BCF57.6000304@schaufler-ca.com>
Message-ID: <alpine.LRH.2.02.1402251847070.29807@tundra.namei.org>
References: <cover.1393279025.git.joe@perches.com> <3b69f0961dff21133e276d5c3edee8b05c41f8c5.1393279025.git.joe@perches.com> <530BC92D.6030509@schaufler-ca.com> <530BCF57.6000304@schaufler-ca.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Casey Schaufler wrote:

> On 2/24/2014 2:35 PM, Casey Schaufler wrote:
> > On 2/24/2014 1:59 PM, Joe Perches wrote:
> >> Convert printks to pr_<level>
> >> Add pr_fmt.
> >>
> >> Signed-off-by: Joe Perches <joe@perches.com>
> > Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> >
> > I will take this into the smack-next tree.
> 
> Unless James would rather take the whole set, that is.

Yep, I'll take the whole set.


> 
> >
> >> ---
> >>  security/smack/smack_lsm.c |  7 ++++---
> >>  security/smack/smackfs.c   | 25 +++++++++++--------------
> >>  2 files changed, 15 insertions(+), 17 deletions(-)
> >>
> >> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> >> index 14f52be..a273aad 100644
> >> --- a/security/smack/smack_lsm.c
> >> +++ b/security/smack/smack_lsm.c
> >> @@ -18,6 +18,8 @@
> >>   *      as published by the Free Software Foundation.
> >>   */
> >>  
> >> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >> +
> >>  #include <linux/xattr.h>
> >>  #include <linux/pagemap.h>
> >>  #include <linux/mount.h>
> >> @@ -2106,8 +2108,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
> >>  		if (sock->sk->sk_family == PF_INET) {
> >>  			rc = smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
> >>  			if (rc != 0)
> >> -				printk(KERN_WARNING
> >> -					"Smack: \"%s\" netlbl error %d.\n",
> >> +				pr_warn("\"%s\" netlbl error %d\n",
> >>  					__func__, -rc);
> >>  		}
> >>  	} else
> >> @@ -3916,7 +3917,7 @@ static __init int smack_init(void)
> >>  	if (tsp == NULL)
> >>  		return -ENOMEM;
> >>  
> >> -	printk(KERN_INFO "Smack:  Initializing.\n");
> >> +	pr_info("Initializing\n");
> >>  
> >>  	/*
> >>  	 * Set the security state for the initial task.
> >> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> >> index 3198cfe..2e25220 100644
> >> --- a/security/smack/smackfs.c
> >> +++ b/security/smack/smackfs.c
> >> @@ -16,6 +16,8 @@
> >>   *
> >>   */
> >>  
> >> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >> +
> >>  #include <linux/kernel.h>
> >>  #include <linux/vmalloc.h>
> >>  #include <linux/security.h>
> >> @@ -698,8 +700,7 @@ static void smk_cipso_doi(void)
> >>  
> >>  	rc = netlbl_cfg_map_del(NULL, PF_INET, NULL, NULL, &nai);
> >>  	if (rc != 0)
> >> -		printk(KERN_WARNING "%s:%d remove rc = %d\n",
> >> -		       __func__, __LINE__, rc);
> >> +		pr_warn("%s:%d remove rc = %d\n", __func__, __LINE__, rc);
> >>  
> >>  	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
> >>  	if (doip == NULL)
> >> @@ -713,15 +714,13 @@ static void smk_cipso_doi(void)
> >>  
> >>  	rc = netlbl_cfg_cipsov4_add(doip, &nai);
> >>  	if (rc != 0) {
> >> -		printk(KERN_WARNING "%s:%d cipso add rc = %d\n",
> >> -		       __func__, __LINE__, rc);
> >> +		pr_warn("%s:%d cipso add rc = %d\n", __func__, __LINE__, rc);
> >>  		kfree(doip);
> >>  		return;
> >>  	}
> >>  	rc = netlbl_cfg_cipsov4_map_add(doip->doi, NULL, NULL, NULL, &nai);
> >>  	if (rc != 0) {
> >> -		printk(KERN_WARNING "%s:%d map add rc = %d\n",
> >> -		       __func__, __LINE__, rc);
> >> +		pr_warn("%s:%d map add rc = %d\n", __func__, __LINE__, rc);
> >>  		kfree(doip);
> >>  		return;
> >>  	}
> >> @@ -741,8 +740,8 @@ static void smk_unlbl_ambient(char *oldambient)
> >>  	if (oldambient != NULL) {
> >>  		rc = netlbl_cfg_map_del(oldambient, PF_INET, NULL, NULL, &nai);
> >>  		if (rc != 0)
> >> -			printk(KERN_WARNING "%s:%d remove rc = %d\n",
> >> -			       __func__, __LINE__, rc);
> >> +			pr_warn("%s:%d remove rc = %d\n",
> >> +				__func__, __LINE__, rc);
> >>  	}
> >>  	if (smack_net_ambient == NULL)
> >>  		smack_net_ambient = &smack_known_floor;
> >> @@ -750,8 +749,7 @@ static void smk_unlbl_ambient(char *oldambient)
> >>  	rc = netlbl_cfg_unlbl_map_add(smack_net_ambient->smk_known, PF_INET,
> >>  				      NULL, NULL, &nai);
> >>  	if (rc != 0)
> >> -		printk(KERN_WARNING "%s:%d add rc = %d\n",
> >> -		       __func__, __LINE__, rc);
> >> +		pr_warn("%s:%d add rc = %d\n", __func__, __LINE__, rc);
> >>  }
> >>  
> >>  /*
> >> @@ -2302,8 +2300,7 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
> >>  
> >>  	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files);
> >>  	if (rc != 0) {
> >> -		printk(KERN_ERR "%s failed %d while creating inodes\n",
> >> -			__func__, rc);
> >> +		pr_err("%s failed %d while creating inodes\n", __func__, rc);
> >>  		return rc;
> >>  	}
> >>  
> >> @@ -2369,13 +2366,13 @@ static int __init init_smk_fs(void)
> >>  
> >>  	err = smk_init_sysfs();
> >>  	if (err)
> >> -		printk(KERN_ERR "smackfs: sysfs mountpoint problem.\n");
> >> +		pr_err("smackfs: sysfs mountpoint problem\n");
> >>  
> >>  	err = register_filesystem(&smk_fs_type);
> >>  	if (!err) {
> >>  		smackfs_mount = kern_mount(&smk_fs_type);
> >>  		if (IS_ERR(smackfs_mount)) {
> >> -			printk(KERN_ERR "smackfs:  could not mount!\n");
> >> +			pr_err("smackfs: could not mount!\n");
> >>  			err = PTR_ERR(smackfs_mount);
> >>  			smackfs_mount = NULL;
> >>  		}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
James Morris
<jmorris@namei.org>

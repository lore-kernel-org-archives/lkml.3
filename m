Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbaICMvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:51:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33079 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbaICMvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:51:06 -0400
Message-ID: <1409748660.21827.55.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 2/8] integrity: remove declaration of non-existing
 functions
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Wed, 03 Sep 2014 08:51:00 -0400
In-Reply-To: <4ae21fa095c234dcb8f6b6ebb7b7fff308448fb8.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
	 <4ae21fa095c234dcb8f6b6ebb7b7fff308448fb8.1409728712.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090312-3532-0000-0000-00000455503D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 10:19 +0300, Dmitry Kasatkin wrote: 
> Noticed that there are declaration of few non-existing functions.
> Also remove duplicated declaration of inegrity_iint_find().

Please include the commits, which removed these functions, in the patch
description.

Mimi
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/ima/ima.h   | 9 ---------
>  security/integrity/integrity.h | 1 -
>  2 files changed, 10 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 0fb456c..c6990a7 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -90,10 +90,7 @@ extern struct list_head ima_measurements;	/* list of all measurements */
> 
>  /* Internal IMA function definitions */
>  int ima_init(void);
> -void ima_cleanup(void);
>  int ima_fs_init(void);
> -void ima_fs_cleanup(void);
> -int ima_inode_alloc(struct inode *inode);
>  int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>  			   const char *op, struct inode *inode,
>  			   const unsigned char *filename);
> @@ -151,12 +148,6 @@ int ima_store_template(struct ima_template_entry *entry, int violation,
>  void ima_free_template_entry(struct ima_template_entry *entry);
>  const char *ima_d_path(struct path *path, char **pathbuf);
> 
> -/* rbtree tree calls to lookup, insert, delete
> - * integrity data associated with an inode.
> - */
> -struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
> -struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
> -
>  /* IMA policy related functions */
>  enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK, FIRMWARE_CHECK, POST_SETATTR };
> 
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 904e68a..c0379d1 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -117,7 +117,6 @@ struct integrity_iint_cache {
>  /* rbtree tree calls to lookup, insert, delete
>   * integrity data associated with an inode.
>   */
> -struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
>  struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
> 
>  #define INTEGRITY_KEYRING_EVM		0



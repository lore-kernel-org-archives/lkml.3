Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbaJOFnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:43:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaJOFnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:43:37 -0400
Date: Tue, 14 Oct 2014 22:43:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rohit Kumar <rohit.kr@samsung.com>
Cc: casey@schaufler-ca.com, james.l.morris@oracle.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpgs@samsung.com, pintu.k@samsung.com, vishnu.ps@samsung.com,
        iqbal.ams@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH 1/1] Security : smack : Use kmem_cache for allocation
 and freeing of inode_smack
Message-Id: <20141014224338.f58a66e5.akpm@linux-foundation.org>
In-Reply-To: <1413352576-30356-1-git-send-email-rohit.kr@samsung.com>
References: <1413352576-30356-1-git-send-email-rohit.kr@samsung.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 11:26:16 +0530 Rohit Kumar <rohit.kr@samsung.com> wrote:

> From: Rohit <rohit.kr@samsung.com>
> 
> Use kmem_cache to allocate/free inode_smack since they are
> alloced in high volumes making it a perfect case for kmem_cache.
> 
> Accounting of memory allocation is below :
>  total           slack            net      count-alloc/free        caller
> Before (with kzalloc)
> 1919872           719952          1919872      29998/0          new_inode_smack+0x14
> After (with kmem_cache)
> 1201680                0          1201680      30042/0          new_inode_smack+0x18
> 
> ...
>
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -53,6 +53,7 @@
>  #define SMK_SENDING	2
>  
>  LIST_HEAD(smk_ipv6_port_list);
> +struct kmem_cache *smack_inode_cache;

static.
  


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaBTVac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:30:32 -0500
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:37212 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750989AbaBTVab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:30:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:4321:5007:7652:10004:10400:10848:11026:11658:11914:12043:12295:12296:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lunch47_78bd0d4178c60
X-Filterd-Recvd-Size: 1966
Message-ID: <1392931828.2594.12.camel@joe-AO722>
Subject: Re: [PATCH 1/1] afs: afs_alloc_inode: use kmem_cache_zalloc
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, dhowells <dhowells@redhat.com>,
        akpm <akpm@linux-foundation.org>
Date: Thu, 20 Feb 2014 13:30:28 -0800
In-Reply-To: <20140220211612.506074a7fd876e47130a8c5c@skynet.be>
References: <20140220211612.506074a7fd876e47130a8c5c@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 21:16 +0800, Fabian Frederick wrote:
> afs_vnode is currently cleared with 2 memsets after allocation and 
> 1 in constructor (afs_i_init_once).

Trivial comments:

> 	-This patch calls zalloc for explicit zero fill.

OK, but see below.

> 	-Fix some typos.

Well...

> diff --git a/fs/afs/super.c b/fs/afs/super.c
[]
> @@ -76,7 +76,7 @@ static const match_table_t afs_options_list = {
[]
> - * initialise the filesystem
> + * Initialize the filesystem
> @@ -448,19 +448,19 @@ error:
[]
> - * initialise an inode cache slab element prior to any use
> + * Initialize an inode cache slab element prior to any use

English spellings don't need to be changed to American.

> @@ -481,15 +481,12 @@ static struct inode *afs_alloc_inode(struct super_block *sb)
[]
> -	vnode = kmem_cache_alloc(afs_inode_cachep, GFP_KERNEL);
> +	vnode = kmem_cache_zalloc(afs_inode_cachep, GFP_KERNEL);
[]
> -	memset(&vnode->fid, 0, sizeof(vnode->fid));
> -	memset(&vnode->status, 0, sizeof(vnode->status));
> -
>  	vnode->volume		= NULL;
>  	vnode->update_cnt	= 0;

These could be removed too.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaEMQfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:35:21 -0400
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:40308 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751107AbaEMQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:35:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:4823:5007:6117:7652:7903:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357:21067,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fall64_84f115175e030
X-Filterd-Recvd-Size: 2056
Message-ID: <1399998910.24350.8.camel@joe-AO725>
Subject: Re: [PATCH 1/1] fs/devpts/inode.c: convert printk to pr_foo()
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, tytso <tytso@mit.edu>,
        akpm <akpm@linux-foundation.org>
Date: Tue, 13 May 2014 09:35:10 -0700
In-Reply-To: <20140513181320.1fbf491f12fab39034ecd702@skynet.be>
References: <20140513181320.1fbf491f12fab39034ecd702@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 18:13 +0200, Fabian Frederick wrote:
> Also convert spaces to tabs (checkpatch warnings)
[]
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
[]

It may be better to add a #define pr_fmt

> @@ -225,7 +225,7 @@ static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
>  			break;
>  #endif
>  		default:
> -			printk(KERN_ERR "devpts: called with bogus options\n");
> +			pr_err("devpts: called with bogus options\n");

and remove all the embedded "devpts: "

> @@ -261,7 +261,7 @@ static int mknod_ptmx(struct super_block *sb)
>  
>  	dentry = d_alloc_name(root, "ptmx");
>  	if (!dentry) {
> -		printk(KERN_NOTICE "Unable to alloc dentry for ptmx node\n");
> +		pr_notice("Unable to alloc dentry for ptmx node\n");
>  		goto out;
>  	}
>  
> @@ -270,7 +270,7 @@ static int mknod_ptmx(struct super_block *sb)
>  	 */
>  	inode = new_inode(sb);
>  	if (!inode) {
> -		printk(KERN_ERR "Unable to alloc inode for ptmx node\n");
> +		pr_err("Unable to alloc inode for ptmx node\n");
>  		dput(dentry);
>  		goto out;
>  	}

Adding pr_fmt would prefix these.

It seems odd that one of these is an err and the other a notice.



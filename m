Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaCPV1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 17:27:20 -0400
Received: from smtprelay0240.hostedemail.com ([216.40.44.240]:40276 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754829AbaCPV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 17:27:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3870:3872:3874:4321:5007:6117:7652:7903:10004:10400:10848:11026:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wave58_229433ebfd205
X-Filterd-Recvd-Size: 1608
Message-ID: <1395005236.31843.1.camel@joe-AO722>
Subject: Re: [PATCH V2] NTFS: Logging clean-up
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, anton <anton@tuxera.com>
Date: Sun, 16 Mar 2014 14:27:16 -0700
In-Reply-To: <20140316215238.ba9af67aa774882cc96f4161@skynet.be>
References: <20140316215238.ba9af67aa774882cc96f4161@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-16 at 21:52 +0100, Fabian Frederick wrote:
> -Convert spinlock/stat array to va_format (inspired by Joe Perches help
> on previous logging patches).
> -Convert printk(KERN_ERR to pr_warn in __ntfs_warning.
> -Convert printk(KERN_ERR to pr_err in __ntfs_error.
> -Convert printk(KERN_DEBUG to pr_debug in __ntfs_debug.
[]
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
[]
> @@ -3093,7 +3094,7 @@ static int __init init_ntfs_fs(void)
>  	int err = 0;
>  
>  	/* This may be ugly but it results in pretty output so who cares. (-8 */
> -	printk(KERN_INFO "NTFS driver " NTFS_VERSION " [Flags: R/"
> +	pr_info(NTFS_VERSION " [Flags: R/"

Be nice to have this say pr_info("driver " NTFS_VERSION " etc...

Other than that, seems like a nice cleanup, thanks.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaAISO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:14:27 -0500
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:52299 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754969AbaAISOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:14:16 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: start61_24f69bda86903
X-Filterd-Recvd-Size: 1618
Message-ID: <1389291252.24222.23.camel@joe-AO722>
Subject: Re: [RFC] Easier printing of unknown-size quantities
From: Joe Perches <joe@perches.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 09 Jan 2014 10:14:12 -0800
In-Reply-To: <20140109134210.GC29910@parisc-linux.org>
References: <20140109134210.GC29910@parisc-linux.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 06:42 -0700, Matthew Wilcox wrote:
> We have a number of types whose sizes are architecture- or
> config-dependent such as pgoff_t or sector_t.  The recommendation for
> printing them is to cast them to (unsigned long long) and print them with
> %Lu/%llx/...  That's entirely reasonable except that it's so verbose.
[]
> diff --git a/fs/buffer.c b/fs/buffer.c
[]
> @@ -148,7 +148,7 @@ static void buffer_io_error(struct buffer_head *bh)
>  {
>  	char b[BDEVNAME_SIZE];
>  	printk(KERN_ERR "Buffer I/O error on device %s, logical block %Lu\n",
> -			bdevname(bh->b_bdev, b),
> -			(unsigned long long)bh->b_blocknr);
> +			bdevname(bh->b_bdev, b), ULL(bh->b_blocknr));
>  }
 
casting to u64 works and is also simpler

	printk(KERN_ERR "Buffer I/O error on device %s, logical block %Lu\n",
			bdevname(bh->b_bdev, b), (u64)bh->b_blocknr);



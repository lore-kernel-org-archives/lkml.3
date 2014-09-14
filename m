Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaINWez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:34:55 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:53060 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752873AbaINWey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:34:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:3872:4321:5007:7557:7652:10004:10400:10848:11026:11232:11473:11658:11914:12296:12517:12519:12740:13069:13161:13229:13311:13357:13848:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: blow64_d712345c9625
X-Filterd-Recvd-Size: 1322
Message-ID: <1410734091.917.26.camel@joe-AO725>
Subject: Re: [PATCH 09/10] f2fs: use MAX_BIO_BLOCKS(sbi)
From: Joe Perches <joe@perches.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Sun, 14 Sep 2014 15:34:51 -0700
In-Reply-To: <1410732864-53069-9-git-send-email-jaegeuk@kernel.org>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
	 <1410732864-53069-9-git-send-email-jaegeuk@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-14 at 15:14 -0700, Jaegeuk Kim wrote:
> This patch cleans up a simple macro.

There seems to be many different types used here.

	MAX_BIO_BLOCKS returns unsigned int
	bio_blocks is int,
	blocks_per_seg is unsigned int,
	ra_meta_pages(,,int,)
	nr_pages_to_skip uses int
	nr_pages_to_write returns a long

Perhaps it'd be nicer to standardize the type
so there'd be fewer promotions/implicit casts.



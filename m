Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab3JOR6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:58:19 -0400
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:37668 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932878Ab3JOR6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:58:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3866:3867:3868:3871:4321:5007:6119:7652:9010:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drum99_8267c5b54cc3d
X-Filterd-Recvd-Size: 1739
Message-ID: <1381859895.22110.30.camel@joe-AO722>
Subject: Re: [PATCH 1/3] kexec: Add debug printing of kimage table entries
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>
Date: Tue, 15 Oct 2013 10:58:15 -0700
In-Reply-To: <1381859307-11932-2-git-send-email-geert@linux-m68k.org>
References: <1381859307-11932-1-git-send-email-geert@linux-m68k.org>
	 <1381859307-11932-2-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 19:48 +0200, Geert Uytterhoeven wrote:
> Print a list of pages to be copied if debugging is enabled.
> Consecutive entries are merged to reduce screen clutter.
[]
> diff --git a/kernel/kexec.c b/kernel/kexec.c
[]
> +static void kimage_print_block(const struct kimage_block *block)
> +{
> +	pr_info("Copy from 0x%lx-0x%lx to 0x%lx-0x%lx (0x%lx bytes)\n",
> +		block->src, block->src + block->len - 1, block->dst,
> +		block->dst + block->len - 1, block->len);
> +}

Perhaps pr_debug and this maybe nicer to read like:

	pr_debug("kimage: Copy from 0x%lx-0x%lx to 0x%lx-0x%lx (0x%lx bytes)\n",
		 block->src, block->src + block->len - 1,
		 block->dst, block->dst + block->len - 1,
		 block->len);

Using a "kimage: " prefix could help grep too.


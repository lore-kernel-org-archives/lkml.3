Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaFPShv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:37:51 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:39816 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932359AbaFPShu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:37:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1461:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3876:3877:4321:5007:6114:6642:7652:7901:10004:10400:10848:11658:11914:12296:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lead36_7e39c078cbd40
X-Filterd-Recvd-Size: 1322
Message-ID: <1402943866.3182.4.camel@joe-AO725>
Subject: Re: [PATCH 1/1] fs/squashfs/file_direct.c: replace count*size
 kmalloc by kcalloc
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 16 Jun 2014 11:37:46 -0700
In-Reply-To: <1402942339-8993-1-git-send-email-fabf@skynet.be>
References: <1402942339-8993-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 20:12 +0200, Fabian Frederick wrote:
> kcalloc manages count*sizeof overflow.

so does kmalloc_array

> diff --git a/fs/squashfs/file_direct.c b/fs/squashfs/file_direct.c
[]
> -	page = kmalloc(sizeof(void *) * pages, GFP_KERNEL);
> +	page = kcalloc(pages, sizeof(void *), GFP_KERNEL);


kmalloc(a * sizeof(b), GFP) -> kmalloc_array(a, sizeof(b), GFP)
kzalloc(a * sizeof(b), GFP) -> kcalloc(a, sizeof(b), GFP)



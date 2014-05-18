Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaERR1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 13:27:18 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:58032 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751570AbaERR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 13:27:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3868:3871:3872:4250:4321:4605:5007:7652:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12664:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: voice39_5022a9aeb046
X-Filterd-Recvd-Size: 1830
Message-ID: <1400434032.21382.3.camel@joe-AO725>
Subject: Re: [PATCH 2/5] staging: lustre: lnet: socklnd: Clean up memset(...)
From: Joe Perches <joe@perches.com>
To: Masaru Nomura <massa.nomura@gmail.com>
Cc: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 18 May 2014 10:27:12 -0700
In-Reply-To: <1400433557-24985-3-git-send-email-massa.nomura@gmail.com>
References: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
	 <1400433557-24985-3-git-send-email-massa.nomura@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-18 at 18:19 +0100, Masaru Nomura wrote:
> Remove prohibited space and fix line over 80 characters of
> memset(...) to meet kernel coding style.
[]
> diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
[]
> @@ -113,7 +113,7 @@ ksocknal_create_peer(ksock_peer_t **peerp, lnet_ni_t *ni, lnet_process_id_t id)
>  	if (peer == NULL)
>  		return -ENOMEM;
>  
> -	memset (peer, 0, sizeof (*peer));       /* NULL pointers/clear flags etc */
> +	memset(peer, 0, sizeof(*peer));     /* NULL pointers/clear flags etc */

It looks like this memset is unnecessary
as it's already zeroed by LIBCFS_ALLOC->
LIBCFS_ALLOC_GFP->LIBCFS_ALLOC_POST->memset.

It seems as if all these ALLOC macros could
use quite a bit of cleaning/sorting out.



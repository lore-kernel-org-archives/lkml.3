Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3JHQST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:18:19 -0400
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:49579 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753442Ab3JHQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:18:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3872:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wall73_d8aa0942a05b
X-Filterd-Recvd-Size: 1371
Message-ID: <1381249090.2081.240.camel@joe-AO722>
Subject: Re: [PATCH] core: Catch overflows in do_div() function
From: Joe Perches <joe@perches.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: linux-kernel@vger.kernel.org, rdunlap@infradead.org
Date: Tue, 08 Oct 2013 09:18:10 -0700
In-Reply-To: <1381248622-27809-1-git-send-email-anatol.pomozov@gmail.com>
References: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com>
	 <1381248622-27809-1-git-send-email-anatol.pomozov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 09:10 -0700, Anatol Pomozov wrote:
> If second parameter passed to this function was 64 then it silently
> truncates to 32 bits. Catch such situation.
[]
> diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
[]
> @@ -25,6 +26,7 @@
>  # define do_div(n,base) ({					\
>  	uint32_t __base = (base);				\
>  	uint32_t __rem;						\
> +	BUG_ON(sizeof(base) > 4 && base >= (1UL<<32));		\

I think this would be better as a BUILD_BUG_ON



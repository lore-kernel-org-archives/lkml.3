Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbbALRNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:13:55 -0500
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:46719 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751054AbbALRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:13:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:4385:5007:6261:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: leaf31_78ca9c6219c17
X-Filterd-Recvd-Size: 2128
Message-ID: <1421082828.9233.13.camel@perches.com>
Subject: Re: [PATCH 1/5] mm/util: add kstrdup_const
From: Joe Perches <joe@perches.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Mike Turquette <mturquette@linaro.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 12 Jan 2015 09:13:48 -0800
In-Reply-To: <1421054323-14430-2-git-send-email-a.hajda@samsung.com>
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
	 <1421054323-14430-2-git-send-email-a.hajda@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 10:18 +0100, Andrzej Hajda wrote:
> The patch adds alternative version of kstrdup which returns pointer
> to constant char array. The function checks if input string is in
> persistent and read-only memory section, if yes it returns the input string,
> otherwise it fallbacks to kstrdup.
> kstrdup_const is accompanied by kfree_const performing conditional memory
> deallocation of the string.

trivia:

> diff --git a/mm/util.c b/mm/util.c
[]
> +void kfree_const(const void *x)
> +{
> +	if (!is_kernel_rodata((unsigned long)x))
> +		kfree(x);
> +}
> +EXPORT_SYMBOL(kfree_const);
[]
> +const char *kstrdup_const(const char *s, gfp_t gfp)
> +{
> +	if (is_kernel_rodata((unsigned long)s))
> +		return s;
> +
> +	return kstrdup(s, gfp);
> +}
> +EXPORT_SYMBOL(kstrdup_const);

I think it'd be nicer if these used the same form
even if it's a vertical line or 2 longer

void kfree_const(const void *x)
{
	if (is_kernel_rodata((unsigned long)x))
		return;

	kfree(x);
}



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaJSBi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 21:38:59 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:51471 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751640AbaJSBi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 21:38:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:4321:5007:6117:6119:6261:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spot83_6b2182408a542
X-Filterd-Recvd-Size: 1941
Message-ID: <1413682735.14629.11.camel@perches.com>
Subject: Re: [PATCH 1/5] lib: string.c:  Added a function strzcpy
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Date: Sat, 18 Oct 2014 18:38:55 -0700
In-Reply-To: <1413669800-6058-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1413669800-6058-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-19 at 00:03 +0200, Rickard Strandqvist wrote:
> Added a function strzcpy which works the same as strncpy,
> but guaranteed to produce the trailing null character.
> 
> There are many places in the code where strncpy used although it
> must be zero terminated, and switching to strlcpy is not an option
> because the string must nonetheless be fyld with zero characters.
[]
> diff --git a/lib/string.c b/lib/string.c
[]
> +char *strzcpy(char *dest, const char *src, size_t count)
> +{
> +	char *tmp = dest;
> +
> +	while (count) {
> +		if ((*tmp = *src) != 0)
> +			src++;
> +		tmp++;
> +		count--;
> +	}
> +
> +	if (dest != tmp)
> +		*--tmp = '\0';
> +
> +	return dest;
> +}

why not

char *strzcpy(char *dest, const char *src, size_t count)
{
	strncpy(dest, src, count)
	if (count)
		dest[count - 1] = 0; /* or '\0' or whatever */

	return dest;
}

maybe use static inline too.



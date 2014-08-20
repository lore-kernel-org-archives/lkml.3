Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaHTOqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:46:53 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:49257 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750819AbaHTOqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:46:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3872:4321:4362:5007:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12296:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beast66_16184b765c44
X-Filterd-Recvd-Size: 2302
Message-ID: <1408546008.23250.23.camel@joe-AO725>
Subject: Re: [PATCH v3 04/11] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 20 Aug 2014 07:46:48 -0700
In-Reply-To: <1408527772-27224-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408527772-27224-5-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 12:42 +0300, Andy Shevchenko wrote:
> This allows user to print a given buffer as an escaped string. The rules are
> applied according to an optional mix of flags provided by additional format
> letters.

Thanks Andy.  Looks good to me.

Very trivial note:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1101,6 +1102,63 @@ char *ip4_addr_string_sa(char *buf, char *end, const struct sockaddr_in *sa,
>  }
>  
>  static noinline_for_stack
> +char *escaped_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> +		     const char *fmt)
> +{
> +	bool found = true;
> +	int count = 1;
> +	unsigned int flags = 0;
> +	int len;
> +
> +	if (spec.field_width == 0)
> +		/* nothing to print */
> +		return buf;
> +
> +	if (ZERO_OR_NULL_PTR(addr))
> +		/* NULL pointer */
> +		return string(buf, end, NULL, spec);

As the code seems more readable than the comments,
it might be better to remove these comments or
maybe move the comment above the test.

	if (spec.field_width == 0)
		return buf;

	if (ZERO_OR_NULL_PTR(addr))
		return string(buf, end, NULL, spec);



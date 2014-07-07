Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaGGQ0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:26:11 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:50140 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750917AbaGGQ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:26:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3871:4250:4321:4605:5007:6119:7652:7875:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12219:12517:12519:12740:13069:13138:13231:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frog20_34f3e3faa7355
X-Filterd-Recvd-Size: 3030
Message-ID: <1404750357.27043.78.camel@joe-AO725>
Subject: Re: [PATCH v2 04/10] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 07 Jul 2014 09:25:57 -0700
In-Reply-To: <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trivial notes]

On Mon, 2014-07-07 at 18:21 +0300, Andy Shevchenko wrote:
> This allows user to print a given buffer as esaped string. The rules applied

as an escaped

> accordingly to the mix of the flags provided by additional format letters.

rules are applied according to an optional mix of flags

> For example, if the given buffer:
> 
> 	1b 62 20 5c 43 07 22 90 0d 5d
> 
> The result strings could be:

would be

> 	%*pE            "\eb \C\a"\220\r]"

Maybe say something about ssid's here.
or maybe add an %*pES just for the ssid type.

> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
[]
> @@ -70,6 +70,34 @@ DMA addresses types dma_addr_t:
>  	For printing a dma_addr_t type which can vary based on build options,
>  	regardless of the width of the CPU data path. Passed by reference.
>  
> +Raw buffer as an escaped string:
> +
> +	%*pE[achnops]
> +
> +	For printing raw buffer as an escaped string. For the following buffer
> +
> +		1b 62 20 5c 43 07 22 90 0d 5d
> +
> +	few examples show how the conversion could be done (the result string
> +	without embraced quotes):

'embraced' is a bit of an awkward word choice.  Maybe surrounding.

> +
> +		%*pE		"\eb \C\a"\220\r]"

Oh, the initial commit log comments above are really for this block

> +		%*pEhp		"\x1bb \C\x07"\x90\x0d]"
> +		%*pEa		"\e\142\040\\\103\a\042\220\r\135"
> +
> +	The converion rules are defined by combination of the following flags

conversion

> +	(see string_escape_mem() kernel documentation for the details):
> +		a - ESCAPE_ANY
> +		c - ESCAPE_SPECIAL
> +		h - ESCAPE_HEX
> +		n - ESCAPE_NULL
> +		o - ESCAPE_OCTAL
> +		p - ESCAPE_NP
> +		s - ESCAPE_SPACE
> +	By default ESCAPE_ANY_NP is used.
> +
> +	If field width is ommited the 1 byte only will be escaped.

omitted



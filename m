Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaGGQuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:50:18 -0400
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:51212 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751112AbaGGQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:50:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3871:4321:5007:7652:7903:10004:10400:10848:11026:11658:11914:12296:12517:12519:12679:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wound39_761c897e90102
X-Filterd-Recvd-Size: 1792
Message-ID: <1404751810.27043.90.camel@joe-AO725>
Subject: Re: [PATCH v2 04/10] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 07 Jul 2014 09:50:10 -0700
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

On Mon, 2014-07-07 at 18:21 +0300, Andy Shevchenko wrote:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
>  static noinline_for_stack
> +char *escaped_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> +		     const char *fmt)
[]
> +	if (spec.field_width == 0)
> +		/* nothing to print */
> +		return buf;
[]
> +	len = spec.field_width < 0 ? 1 : spec.field_width;

If field_width is not specified, emit a single byte?

Perhaps better if -1 was accepted by string_escape_mem
as a strlen request or just ignored as a 0 length is
above.

fyi: hex_string emits nothing on printk("%ph", buf);



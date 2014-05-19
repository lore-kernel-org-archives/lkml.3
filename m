Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819AbaESTxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:53:24 -0400
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:59827 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751435AbaESTxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:53:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3872:4321:5007:7652:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: birth11_1d42e9db07c30
X-Filterd-Recvd-Size: 1759
Message-ID: <1400529199.14238.24.camel@joe-AO725>
Subject: Re: [PATCH 1/1] fs/jffs2/compr.c: remove 0 assignment on static
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>
Date: Mon, 19 May 2014 12:53:19 -0700
In-Reply-To: <20140519213145.e75dbd1aa74fc2ccd9193686@skynet.be>
References: <20140519213145.e75dbd1aa74fc2ccd9193686@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 21:31 +0200, Fabian Frederick wrote:
> static values are automatically initialized to NULL
[]
> diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
[]
> @@ -25,7 +25,8 @@ static LIST_HEAD(jffs2_compressor_list);
>  static int jffs2_compression_mode = JFFS2_COMPR_MODE_PRIORITY;
>  
>  /* Statistics for blocks stored without compression */
> -static uint32_t none_stat_compr_blocks=0,none_stat_decompr_blocks=0,none_stat_compr_size=0;
> +static uint32_t none_stat_compr_blocks, none_stat_decompr_blocks,
> +		none_stat_compr_size;

Maybe nicer on 3 lines.

static uint32_t none_stat_compr_blocks;
static uint32_t none_stat_decompr_blocks,
static uint32_t none_stat_compr_size;

These none_stat_<foo> variables seem to
be write only so it'd probably be better
to remove them instead.

Maybe all the uint32_t uses in fs/jffs2/
would be nicer as u32.



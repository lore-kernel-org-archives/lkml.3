Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3KLAp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:45:56 -0500
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:54984 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752905Ab3KLApr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:45:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2553:2559:2562:2692:2828:2892:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3873:4321:4605:5007:7652:8603:10004:10400:10848:10967:11232:11658:11914:12043:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Ne
X-HE-Tag: brain61_14f75d4970017
X-Filterd-Recvd-Size: 2648
Message-ID: <1384217148.4771.9.camel@joe-AO722>
Subject: Re: [PATCH] block: cmdline-parser: perfect cmdline format checking
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Caizhiyong <caizhiyong@hisilicon.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Karel Zak <kzak@redhat.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Date: Mon, 11 Nov 2013 16:45:48 -0800
In-Reply-To: <20131111153420.d4e9c4ef2a90e70bfb01fd83@linux-foundation.org>
References: <C3050A4DBA34F345975765E43127F10F1C08B3FB@szxeml512-mbs.china.huawei.com>
	 <20131111153420.d4e9c4ef2a90e70bfb01fd83@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 15:34 -0800, Andrew Morton wrote:
> On Sat, 9 Nov 2013 11:45:14 +0000 Caizhiyong <caizhiyong@hisilicon.com> wrote:
[]
> >  -perfect cmdline format checking, make the error information clear
> >   for understand, make this lib fully equivalent to the old parser
> >   in drivers/mtd/cmdlinepart.c
> > 
> > ...
> >
> > +#define PARSER                       "cmdline-parser: "
> > ...
> > -			pr_warn("cmdline partition size is invalid.");
> > +			pr_warn(PARSER "partition '%s' size '0x%llx' too small.",
> 
> You can use the standard pr_fmt() mechanism instead of this.
[]
> diff -puN block/cmdline-parser.c~mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix block/cmdline-parser.c
[]
> @@ -21,10 +26,12 @@ static int parse_subpart(struct cmdline_
>  	if (*partdef == '-') {
>  		new_subpart->size = (sector_t)(~0ULL);
>  		partdef++;
> +		lastpart = 1;
>  	} else {
>  		new_subpart->size = (sector_t)memparse(partdef, &partdef);
>  		if (new_subpart->size < (sector_t)PAGE_SIZE) {
> -			pr_warn("cmdline partition size is invalid.");
> +			pr_warn(PARSER "partition '%s' size '0x%llx' too small.",
> +				partorg, new_subpart->size);

As well, please add terminating '\n' newlines to all the formats.
This helps avoid possible logging message interleaving.



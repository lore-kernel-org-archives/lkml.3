Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbaGRUjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:39:36 -0400
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:53013 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755047AbaGRUjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:39:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3872:3874:4321:4605:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: iron95_8dabe689d390b
X-Filterd-Recvd-Size: 2301
Message-ID: <1405715972.14358.81.camel@joe-AO725>
Subject: Re: [PATCH 1/1] checkpatch.pl: 1-tab relative indent for
 conditionals/blocks
From: Joe Perches <joe@perches.com>
To: Gregory Fong <gregory.0xf0@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Jul 2014 13:39:32 -0700
In-Reply-To: <1405712447-18788-1-git-send-email-gregory.0xf0@gmail.com>
References: <1405712447-18788-1-git-send-email-gregory.0xf0@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 12:40 -0700, Gregory Fong wrote:
> The following would incorrectly pass checkpatch:
> 
> void foo(void)
> {
>         if (a) {
>                 something;
>                 somethingelse;
>         } else {
>                         messed_up_indentation;
>                 }
> }
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2606,6 +2607,7 @@ sub process {
>  			#print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s> cond_lines<$cond_lines> stat_real<$stat_real> stat<$stat>\n";
>  
>  			if ($check && (($sindent % 8) != 0 ||
> +			    ((($sindent - $indent) / 8) > 1) ||
>  			    ($sindent <= $indent && $s ne ''))) {
>  				WARN("SUSPECT_CODE_INDENT",
>  				     "suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");

This might be better testing only tab indented lines like:

	if ($check &&
	    length($prevtabindent) + 1 != length($tabindent))

It'd also be useful to check non-conditional, non-blank
after decommenting code lines so that a block like:

static bool func(void)
{
	bool b;
		/* comment about something */
		int a[2] = foo();

		b = a[0] == a[1];

	/* ready to return */
	return b;
}

emits a couple of "suspect code indent" warnings.
One on int a[2], another on return b.



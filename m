Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3I3Pua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:50:30 -0400
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:37297 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754637Ab3I3Pu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:50:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7903:8957:10004:10400:10848:11658:11914:12043:12295:12517:12519:12740:13069:13071:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: money75_20b778a056e1c
X-Filterd-Recvd-Size: 2139
Message-ID: <1380556223.30647.10.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: warn about incorrect __initdata placement
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Mon, 30 Sep 2013 08:50:23 -0700
In-Reply-To: <1534354.yq7QTJSTju@amdc1032>
References: <1534354.yq7QTJSTju@amdc1032>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-30 at 15:23 +0200, Bartlomiej Zolnierkiewicz wrote:
> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4275,6 +4275,12 @@ sub process {
[]
> +# check for incorrect __initdata placement
> +		if ($line =~ /\bstruct\s+__initdata.*\=/) {
> +			WARN("INITDATA_PLACEMENT",
> +			     "__initdata tag should be placed between the variable name and equal sign\n" . $herecurr);
> +		}

Hello Bartlomiej

I believe that -next commit 12de1c1ad0df
("checkpatch: add rules to check init attribute and const defects")

which adds $InitAttribute already does this test.

Anyway, this should be:
	if ($line =~ /\b(struct|union)\s+$InitAttribute.*=/) {

and please add this test adjacent to the other $InitAttribute
tests only if it's not already covered by the first bit added
by that commit below (again, I believe it is):

------------------------

# check for bad placement of section $InitAttribute (e.g.: __initdata)
		if ($line =~ /(\b$InitAttribute\b)/) {
			my $attr = $1;
			if ($line =~ /^\+\s*static\s+(?:const\s+)?(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*[=;]/) {



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaCCRvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:51:44 -0500
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:59397 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751012AbaCCRvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:51:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4384:5007:6119:7652:7903:9010:10004:10400:10848:11232:11658:11914:12043:12517:12519:12663:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plot84_e648bffce818
X-Filterd-Recvd-Size: 2165
Message-ID: <1393869097.13719.88.camel@joe-AO722>
Subject: Re: [PATCH v2 2/2] checkpatch: fix spurious vendor compatible
 warnings
From: Joe Perches <joe@perches.com>
To: florian.vaussard@epfl.ch
Cc: Andy Whitcroft <apw@canonical.com>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Mar 2014 09:51:37 -0800
In-Reply-To: <53145D21.4080101@epfl.ch>
References: <1393604742-14317-1-git-send-email-florian.vaussard@epfl.ch>
	 <1393604742-14317-3-git-send-email-florian.vaussard@epfl.ch>
	 <1393621571.10280.49.camel@joe-AO722> <53145D21.4080101@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 11:44 +0100, Florian Vaussard wrote:
> Looking at the current documentation, the list of these generic
> placeholders is pretty short:
> 
> $ git grep ',<.*>-' Documentation/devicetree/bindings/ | \
>   grep -P -o ',<.*?>-' | grep -P -o '<.*>' | sort | uniq
> 
> <board>
> <chip>
> <chip name>
> <mcu-chip>
> <processor>
> <soc>
> <SOC>
> <soc-family>
> 
> so '[a-zA-Z0-9-]+' seems more reasonable indeed.

The <mcu-chip> use seems as if it's 2 wildcards

	fsl,<mcu-chip>-<board>

I'm not sure that could work with the current
checkpatch code.

There's a space in "<chip name>" that should
probably be replaced by "<chip-name>" or just
"<chip>" for consistency.

> $compat2 =~ s/\,[a-zA-Z0-9]*\-/<\.\*>\-/g;

hand-escaped, not necessary if using "\Q$compat2\E"

Anyway, if either you or Rob think it appropriate to
submit a patch for either of the things I mentioned
in the first place:

> o Look for ".compatible = "foo" strings in .c and .h files
> o Improve the vendor name match in vendor-prefix.txt by only
>   matching the exact vendor name at the beginning of lines.

or any of the stuff above here, please do.


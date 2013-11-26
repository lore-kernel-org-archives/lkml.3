Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab3KZQnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:43:51 -0500
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:40481 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757253Ab3KZQnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:43:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:2914:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3874:4321:5007:6119:7576:7652:7875:7901:7903:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12679:12740:13019:13069:13071:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: car90_20ff4d38e331e
X-Filterd-Recvd-Size: 2531
Message-ID: <1385484225.20100.58.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: add DT compatible string documentation check
From: Joe Perches <joe@perches.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Tue, 26 Nov 2013 08:43:45 -0800
In-Reply-To: <1385481675-26675-1-git-send-email-robherring2@gmail.com>
References: <1385481675-26675-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 10:01 -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>

Hi Rob.

> This adds a simple check that any compatible strings in DeviceTree dts
> files are present in Documentation/devicetree/bindings. This should be a
> temporary check until we have more sophisticated binding schema checking.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2034,6 +2034,21 @@ sub process {
>  			     "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement->{$flag});
>  		}
>  
> +# check for compatible documentation
> +		if ($realfile =~ /\.dts/ && $rawline =~ /\+\s*compatible\s*=/) {
> +			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,]+)\"/g;

I believe there needs to be a \+\. in the brackets
for lines like:

arch/c6x/boot/dts/tms320c6678.dtsi: compatible = "ti,c64x+timer64";
and
arch/powerpc/boot/dts/mpc8313erdb.dts: compatible = "fsl,sec2.2", "fsl,sec2.1",

> +
> +			foreach my $compat (@compats) {
> +				my $compat2 = $compat;
> +				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
> +				`egrep -rq "$compat|$compat2" "Documentation/devicetree/bindings/"`;

Perhaps the egrep should be grep -E

> +				if ( $? >> 8 ) {
> +					WARN("UNDOCUMENTED_DT_BINDING",
> +					     "DT compatible string \"$compat\" appears un-documented -- check Documentation/devicetree/bindings/\n" . $herecurr);
> +				}
> +			}
> +		}
> +
>  # check we are in a valid source file if not then ignore this hunk
>  		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
>  




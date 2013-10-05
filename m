Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3JESvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 14:51:52 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:39536 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752305Ab3JESvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 14:51:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:966:982:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3698:3742:3865:3866:3867:3868:3870:3871:3873:4250:4321:4385:4605:5007:6119:6120:7652:7901:10004:10226:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: word59_fe4f87c2e915
X-Filterd-Recvd-Size: 1997
Message-ID: <1380999108.2081.138.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 05 Oct 2013 11:51:48 -0700
In-Reply-To: <20131005184307.GA6429@leaf>
References: <20131005184307.GA6429@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-05 at 11:43 -0700, Josh Triplett wrote:
> Kernel maintainers reject new instances of the GPL boilerplate paragraph
> directing people to write to the FSF for a copy of the GPL, since the
> FSF has moved in the past and may do so again.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -1859,6 +1859,16 @@ sub process {
>  			$rpt_cleaners = 1;
>  		}
>  
> +# Check for FSF mailing addresses.
> +		if ($rawline =~ /You should have received a copy/ ||

There are over 9,000 of these in the tree.

> +		    $rawline =~ /write to the Free Software/ ||

Over 7,000

> +		    $rawline =~ /59 Temple Place/ ||

Over 3,500

> +		    $rawline =~ /51 Franklin Street/) {

Over 1,500

> +			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
> +			ERROR("FSF_MAILING_ADDRESS",
> +			      "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)

Is this really a useful ERROR condition?
Maybe a CHK --strict test or a warning instead?


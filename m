Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaLTUtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:49:42 -0500
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:54010 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751163AbaLTUtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:49:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2525:2561:2564:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3653:3865:3866:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6261:8599:9025:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12555:12740:12783:13019:13069:13311:13357:13846:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pig50_5450a8bdb1554
X-Filterd-Recvd-Size: 2176
Message-ID: <1419108577.25129.33.camel@perches.com>
Subject: Re: [PATCH] checkpatch: add check for keyword 'boolean' in Kconfig
 definitions
From: Joe Perches <joe@perches.com>
To: Christoph Jaeger <cj@linux.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org, dborkman@redhat.com,
        pebolle@tiscali.nl
Date: Sat, 20 Dec 2014 12:49:37 -0800
In-Reply-To: <1419108036-11536-1-git-send-email-cj@linux.com>
References: <1419108036-11536-1-git-send-email-cj@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Andrew Morton)

On Sat, 2014-12-20 at 15:40 -0500, Christoph Jaeger wrote:
> Discourage the use of keyword 'boolean' for type definition attributes of
> config options as support for it will be dropped later on.
> 
> Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
> Suggested-by: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Christoph Jaeger <cj@linux.com>

Seems sensible.

> ---
>  scripts/checkpatch.pl | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index f0bb6d6..cae974e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2355,6 +2355,13 @@ sub process {
>  			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
>  		}
>  
> +# discourage the use of boolean for type definition attributes of Kconfig options
> +		if ($realfile =~ /Kconfig/ &&
> +		    $line =~ /^\+\s*\bboolean\b/) {
> +			WARN("CONFIG_TYPE_BOOLEAN",
> +			     "Use of boolean is deprecated, please use bool instead.\n" . $herecurr);
> +		}
> +
>  		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
>  		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
>  			my $flag = $1;




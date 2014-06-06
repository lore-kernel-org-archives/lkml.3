Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaFFBgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 21:36:04 -0400
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:35224 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419AbaFFBgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 21:36:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:2829:3138:3139:3140:3141:3142:3354:3622:3653:3742:3865:3867:3868:3870:3871:3872:3874:4321:4605:5007:7652:7903:8603:8957:9007:9010:9040:9121:10004:10400:10482:10848:11026:11232:11233:11473:11658:11914:12438:12517:12519:12555:12740:13019:13095:19901:19997:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coil20_514689cefa719
X-Filterd-Recvd-Size: 3338
Message-ID: <1402018556.3038.2.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
From: Joe Perches <joe@perches.com>
To: Bruce Allan <bruce.w.allan@intel.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org,
        postmaster <postmaster@vger.kernel.org>
Date: Thu, 05 Jun 2014 18:35:56 -0700
In-Reply-To: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
References: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 17:00 -0700, Bruce Allan wrote:
> the maximum message size (100,000 characters) allowed by Majordomo at
> vger.kernel.org since that is where most Linux email lists are served.

I believe this is incorrect and the patch is unnecessary.

It'd maybe more interesting if the email header sizes
were calculated and if > 1024, then some bleating message
were emitted.

> Also provide a command-line option to specify a different maximum size.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> ---
> 
>  scripts/checkpatch.pl |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 34eb216..79bd7fd6 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -40,6 +40,7 @@ my @ignore = ();
>  my $help = 0;
>  my $configuration_file = ".checkpatch.conf";
>  my $max_line_length = 80;
> +my $max_msg_size = 100000;	# Max allowed by Majordomo at vger.kernel.org
>  my $ignore_perl_version = 0;
>  my $minimum_perl_version = 5.10.0;
>  
> @@ -62,6 +63,7 @@ Options:
>    --types TYPE(,TYPE2...)    show only these comma separated message types
>    --ignore TYPE(,TYPE2...)   ignore various comma separated message types
>    --max-line-length=n        set the maximum line length, if exceeded, warn
> +  --max-msg-size=n           set the maximum message size, if exceeded, warn
>    --show-types               show the message "types" in the output
>    --root=PATH                PATH to the kernel tree root
>    --no-summary               suppress the per-file summary
> @@ -130,6 +132,7 @@ GetOptions(
>  	'types=s'	=> \@use,
>  	'show-types!'	=> \$show_types,
>  	'max-line-length=i' => \$max_line_length,
> +	'max-msg-size=i' => \$max_msg_size,
>  	'root=s'	=> \$root,
>  	'summary!'	=> \$summary,
>  	'mailback!'	=> \$mailback,
> @@ -4600,6 +4603,18 @@ sub process {
>  		exit(0);
>  	}
>  
> +	# Warn if patch exceeds the maximum message size
> +	if (!$file) {
> +		my $cnt_chars = 0;
> +		foreach my $rawline (@rawlines) {
> +			$cnt_chars += length($rawline) + 1;
> +		}
> +		if ($cnt_chars > $max_msg_size) {
> +			WARN("PATCH_TOO_LARGE",
> +			     "patch exceeds maximum message size ($max_msg_size) and might be blocked by email list server(s).\n");
> +		}
> +	}
> +
>  	if (!$is_patch) {
>  		ERROR("NOT_UNIFIED_DIFF",
>  		      "Does not appear to be a unified-diff format patch\n");
> 




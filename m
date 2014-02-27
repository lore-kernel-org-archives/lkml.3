Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaB0UKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:10:14 -0500
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:55798 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751051AbaB0UKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:10:12 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2332:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3867:3870:3871:4321:4605:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13069:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coach93_75f634566c71a
X-Filterd-Recvd-Size: 2179
Message-ID: <1393531808.24588.119.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: fix spurious vendor compatible warnings
From: Joe Perches <joe@perches.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Andy Whitcroft <apw@canonical.com>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Feb 2014 12:10:08 -0800
In-Reply-To: <1393531019-25134-1-git-send-email-florian.vaussard@epfl.ch>
References: <1393531019-25134-1-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 20:56 +0100, Florian Vaussard wrote:
> With a compatible string like
> 
> compatible = "foo";
> 
> checkpatch will currently try to find "foo" in  vendor-prefixes.txt,
> which is wrong since the vendor prefix is empty in this specific case.
> 
> Skip the vendor test if the compatible is not like
> 
> compatible = "vendor,something";
> 
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  scripts/checkpatch.pl | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 464dcef..35ec185 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2058,6 +2058,7 @@ sub process {
>  				my $vendor = $compat;
>  				my $vendor_path = $dt_path . "vendor-prefixes.txt";
>  				next if (! -f $vendor_path);
> +				next if not $vendor =~ /^[a-zA-Z0-9]+\,.*/;
>  				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
>  				`grep -Eq "$vendor" $vendor_path`;
>  				if ( $? >> 8 ) {

Some vendor names have dashes.
I don't know if underscores are allowed.

$ grep -rP --include=*.[ch] -oh "compatible\s*=\s*\"[^,]+,\w" * | \
  sed -r -e 's/\s//g' -e 's/,.$//' | sort | uniq -c | grep "[_-]"
      1 compatible="active-semi
      8 compatible="asahi-kasei



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaKJTuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:50:22 -0500
Received: from smtprelay0086.hostedemail.com ([216.40.44.86]:56500 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751949AbaKJTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:50:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3867:3868:3870:3872:4250:4321:5007:6119:6261:7903:8603:8957:9010:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: badge62_2c37c1cfe325
X-Filterd-Recvd-Size: 2561
Message-ID: <1415649017.8868.15.camel@perches.com>
Subject: Re: [PATCHv2] checkpatch: Allow certain SI units with three
 characters
From: Joe Perches <joe@perches.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 11:50:17 -0800
In-Reply-To: <1415648371-10586-1-git-send-email-jwerner@chromium.org>
References: <1415405880-8520-1-git-send-email-jwerner@chromium.org>
	 <1415407132.23530.23.camel@perches.com>
	 <1415648371-10586-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 11:39 -0800, Julius Werner wrote:
> Checkpatch flags CamelCase identifiers in strict mode, but it has a
> feature to ignore parts with only two characters to allow for SI units
> like mV or uA. Unfortunately, not all SI units fit in two characters,
> and not all are lower case followed by upper case.
> 
> This patch adds hardcoded detection for frequency and 1024-based size
> units (Hz/KHz/MHz/GHz/THz and KiB/MiB/GiB/TiB), since allowing any three
> character combinations might be too lenient. The list can later be
> expanded as needed.

Seems sensible enough, thanks.

Acked-by: Joe Perches <joe@perches.com>

> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  scripts/checkpatch.pl | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 374abf4..b947c75 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4056,7 +4056,9 @@ sub process {
>  #Ignore Page<foo> variants
>  			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
>  #Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
> -			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/) {
> +			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/ &&
> +#Ignore some three character SI units explicitly, like MiB and KHz
> +			    $var !~ /^(?:[a-z_]*?)_?(?:[KMGT]iB|[KMGT]?Hz)(?:_[a-z_]+)?$/) {
>  				while ($var =~ m{($Ident)}g) {
>  					my $word = $1;
>  					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);




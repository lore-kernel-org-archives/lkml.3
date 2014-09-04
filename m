Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaIDJSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:18:50 -0400
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:60081 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751480AbaIDJSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:18:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:334:355:368:369:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2393:2559:2562:2687:2828:3138:3139:3140:3141:3142:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:7652:7903:8957:9040:9121:10011:10848:11026:11232:11233:11658:11914:12296:12438:12517:12519:12555:12740:13095:13141:13230:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: face78_2f5cc939bf42e
X-Filterd-Recvd-Size: 5386
Message-ID: <1409822323.2715.15.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: allow optional shorter config descriptions
From: Joe Perches <joe@perches.com>
To: Vadim Bendebury <vbendeb@chromium.org>
Cc: subssriprions@vsbe.com, vb@vsbe.com, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 04 Sep 2014 02:18:43 -0700
In-Reply-To: <1409761945-545-1-git-send-email-vbendeb@chromium.org>
References: <1409761945-545-1-git-send-email-vbendeb@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 09:32 -0700, Vadim Bendebury wrote:
> This script is used by many other projects, and in some of them the
> requirement of at least 4 line long description for all Kconfig items
> is excessive. This patch adds a command line option to control the
> required minimum length.
> 
> Tested running this script over a patch including a two line config
> description. The script generated a warning when invoked as is, and
> did not generate it when invoked with --min-conf-desc-length=2.
> 
> Signed-off-by: Vadim Bendebury <vbendeb@chromium.org>
> ---
> 
>  scripts/checkpatch.pl | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b385bcb..8808bde 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -43,6 +43,7 @@ my $configuration_file = ".checkpatch.conf";
>  my $max_line_length = 80;
>  my $ignore_perl_version = 0;
>  my $minimum_perl_version = 5.10.0;
> +my $min_conf_desc_length = 4;
>  
>  sub help {
>  	my ($exitcode) = @_;
> @@ -63,6 +64,7 @@ Options:
>    --types TYPE(,TYPE2...)    show only these comma separated message types
>    --ignore TYPE(,TYPE2...)   ignore various comma separated message types
>    --max-line-length=n        set the maximum line length, if exceeded, warn
> +  --min-conf-desc-length=n   set the min description length, if shorter, warn
>    --show-types               show the message "types" in the output
>    --root=PATH                PATH to the kernel tree root
>    --no-summary               suppress the per-file summary
> @@ -131,6 +133,7 @@ GetOptions(
>  	'types=s'	=> \@use,
>  	'show-types!'	=> \$show_types,
>  	'max-line-length=i' => \$max_line_length,
> +	'min-conf-desc-length=i' => \$min_conf_desc_length,
>  	'root=s'	=> \$root,
>  	'summary!'	=> \$summary,
>  	'mailback!'	=> \$mailback,
> @@ -2281,7 +2284,8 @@ sub process {
>  				$length++;
>  			}
>  			WARN("CONFIG_DESCRIPTION",
> -			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
> +			     "please write a paragraph that describes the config symbol fully\n" . $herecurr)
> +			    if ($is_start && $is_end && $length < $min_conf_desc_length);
>  			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
>  		}

Fine by me, but I think think this is the
only checkpatch use of:

	WARN(foo) if (test);

Every other checkpatch message block is:

	if (test) {
		WARN(foo);
	}

so I would prefer to change this use
to match.
---
 scripts/checkpatch.pl | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d89857d..af4659c1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -43,6 +43,7 @@ my $configuration_file = ".checkpatch.conf";
 my $max_line_length = 80;
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
+my $min_conf_desc_length = 4;
 
 sub help {
 	my ($exitcode) = @_;
@@ -63,6 +64,7 @@ Options:
   --types TYPE(,TYPE2...)    show only these comma separated message types
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
   --max-line-length=n        set the maximum line length, if exceeded, warn
+  --min-conf-desc-length=n   set the min description length, if shorter, warn
   --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
@@ -131,6 +133,7 @@ GetOptions(
 	'types=s'	=> \@use,
 	'show-types!'	=> \$show_types,
 	'max-line-length=i' => \$max_line_length,
+	'min-conf-desc-length=i' => \$min_conf_desc_length,
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
@@ -2280,9 +2283,10 @@ sub process {
 				}
 				$length++;
 			}
-			WARN("CONFIG_DESCRIPTION",
-			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
-			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
+			if ($is_start && $is_end && $length < $min_conf_desc_length) {
+				WARN("CONFIG_DESCRIPTION",
+				     "please write a paragraph that describes the config symbol fully\n" . $herecurr);
+			}
 		}
 
 # discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.



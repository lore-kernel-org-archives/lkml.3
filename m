Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaJQSoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:44:13 -0400
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:58786 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753298AbaJQSoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:44:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3867:3868:3871:3872:3874:4250:4321:4605:5007:6261:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13095:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: side68_41765f31de01b
X-Filterd-Recvd-Size: 2091
Message-ID: <1413571448.14629.4.camel@perches.com>
Subject: Re: [PATCH] scripts, checkpatch.pl, provide a better output message
 for commit id format errors
From: Joe Perches <joe@perches.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 17 Oct 2014 11:44:08 -0700
In-Reply-To: <1413556495-12965-1-git-send-email-prarit@redhat.com>
References: <1413556495-12965-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-17 at 10:34 -0400, Prarit Bhargava wrote:
> I put together a patch with an incorrect format and the following error
> was returned by checkpatch.pl:
> 
> ERROR: Please use 12 or more chars for the git commit ID like: 'Commit
> 09ec54429c6d ("clocksource: Move cycle_last validation to core code")'
> Commit 09ec54429c6d10f87d1f084de53ae2c1c3a81108, clocksource: Move
> 
> The message is confusing.  Change it to request that the author use the
> example commit ID format.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2174,7 +2174,7 @@ sub process {
>  			my $desc = 'commit description';
>  		        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
>  			ERROR("GIT_COMMIT_ID",
> -			      "Please use 12 or more chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
> +			      "Please format the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
>  		}
>  
>  # Check for added, moved or deleted files

This doesn't show that a commit ID may be too short.
Maybe there should be multiple error messages depending
on what is not correct about the original.



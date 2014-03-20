Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaCTKIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:08:25 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:35403 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750743AbaCTKIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:08:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:4425:4605:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: side03_ee2852a2f84d
X-Filterd-Recvd-Size: 2068
Message-ID: <1395310100.7776.3.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Add check for Change-Id
From: Joe Perches <joe@perches.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 03:08:20 -0700
In-Reply-To: <1395255293-3419-1-git-send-email-cov@codeaurora.org>
References: <1395255293-3419-1-git-send-email-cov@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 14:54 -0400, Christopher Covington wrote:
> A commit hook for the Gerrit code review server inserts change
> identifiers so Gerrit can track patches through multiple revisions.
> These identifiers are noise in the context of the upstream kernel.
> (Many Gerrit servers are private. Even given a public instance,
> given only a Change-Id, one must guess which server a change was
> tracked on. Patches submitted to the Linux kernel mailing lists
> should be able to stand on their own. If it's truly useful to
> reference code review on a Gerrit server, a URL is a much clearer
> way to do so.) Thus, issue an error when a Change-Id: line is
> encountered.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -1891,6 +1891,12 @@ sub process {
>  			}
>  		}
>  
> +# Check for unwanted Gerrit info
> +		if ($line =~ /^\s*change-id:/i) {
> +			ERROR("BAD_SIGN_OFF",
> +			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
> +		}
> +

I think this needs an "$in_commit_log" test added

		if ($in_commit_log &&
		    $line =~ /^\s*change-id:/i) {

And maybe use a separate "TYPE", not "BAD_SIGN_OFF".
Maybe "GERRIT_CHANGE_ID"


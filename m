Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaKIJua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:50:30 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35855 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaKIJu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:50:28 -0500
Date: Sun, 9 Nov 2014 10:50:25 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Add --strict preference for #defines using
 BIT(foo)
Message-ID: <20141109095025.GA1840@nanopsycho.orion>
References: <1415265610-9338-1-git-send-email-jiri@resnulli.us>
 <1415265610-9338-10-git-send-email-jiri@resnulli.us>
 <20141107.151607.480474516800359791.davem@davemloft.net>
 <1415394939.23530.20.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415394939.23530.20.camel@perches.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fri, Nov 07, 2014 at 10:15:39PM CET, joe@perches.com wrote:
>Using BIT(foo) and BIT_ULL(bar) is more common now.
>Suggest using these macros over #defines with 1<<value.

Joe, regarding the other Dave's comment, the multiline one, that is also
not covered by checkpatch. Would please you take care of that as well?

Thanks.

>
>Add a --fix option too.
>
>Signed-off-by: Joe Perches <joe@perches.com>
>---
> scripts/checkpatch.pl | 11 +++++++++++
> 1 file changed, 11 insertions(+)
>
>diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>index 893cbd5..b5dc3f4 100755
>--- a/scripts/checkpatch.pl
>+++ b/scripts/checkpatch.pl
>@@ -4973,6 +4973,17 @@ sub process {
> 			}
> 		}
> 
>+# check for #defines like: 1 << <digit> that could be BIT(digit)
>+		if ($line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
>+			my $ull = "";
>+			$ull = "_ULL" if (defined($1) && $1 =~ /ll/i);
>+			if (CHK("BIT_MACRO",
>+				"Prefer using the BIT$ull macro\n" . $herecurr) &&
>+			    $fix) {
>+				$fixed[$fixlinenr] =~ s/\(?\s*1\s*[ulUL]*\s*<<\s*(\d+|$Ident)\s*\)?/BIT${ull}($1)/;
>+			}
>+		}
>+
> # check for case / default statements not preceded by break/fallthrough/switch
> 		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
> 			my $has_break = 0;
>
>

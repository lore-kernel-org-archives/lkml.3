Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3LZUJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 15:09:39 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36000 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3LZUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 15:09:38 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 26 Dec 2013 12:09:32 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] checkpatch: check for if's with unnecessary
 parentheses
Message-ID: <20131226200932.GC7267@leaf>
References: <cover.1388085015.git.joe@perches.com>
 <c338a811bcaab4c3b684cf50575722af8d286865.1388085015.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c338a811bcaab4c3b684cf50575722af8d286865.1388085015.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 11:20:31AM -0800, Joe Perches wrote:
> If statements don't need multiple parentheses around tested
> comparisons like "if ((foo == bar))".
> 
> An == comparison maybe a sign of an intended assignment,
> so emit a slightly different message if so.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  scripts/checkpatch.pl | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index db72b88..c12234e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3322,6 +3322,20 @@ sub process {
>  			}
>  		}
>  
> +# if statements using unnecessary parentheses - ie: if ((foo == bar))
> +		if ($^V && $^V ge 5.10.0 &&
> +		    $line =~ /\bif\s*((?:\(\s*){2,})/) {
> +			my $openparens = $1;
> +			my $count = $openparens =~ tr@\(@\(@;
> +			my $msg = "";
> +			if ($line =~ /\bif\s*(?:\(\s*){$count,$count}$LvalOrFunc\s*($Compare)\s*$LvalOrFunc(?:\s*\)){$count,$count}/) {
> +				my $comp = $4;	#Not $1 because of $LvalOrFunc
> +				$msg = " - maybe == should be = ?" if ($comp eq "==");
> +				WARN("UNNECESSARY_PARENTHESES",
> +				     "Unnecessary parentheses$msg\n" . $herecurr);
> +			}
> +		}
> +
>  # Return of what appears to be an errno should normally be -'ve
>  		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
>  			my $name = $1;
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936837Ab3DJJ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:56:26 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:42190 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3DJJ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:56:25 -0400
X-Greylist: delayed 1327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Apr 2013 05:56:25 EDT
Date: Wed, 10 Apr 2013 10:33:46 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
Message-ID: <20130410093346.GO7511@dm>
References: <1365563834.27174.12.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365563834.27174.12.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 08:17:14PM -0700, Joe Perches wrote:
> Comparisons of A to true and false are better written
> as A and !A.
> 
> Bleat a message on use.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 3fb6d86..080e7f6 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3538,6 +3538,23 @@ sub process {
>  			     "Using yield() is generally wrong. See yield() kernel-doc (sched/core.c)\n"  . $herecurr);
>  		}
>  
> +# check for comparisons against true and false
> +		if ($line =~ /\+\s*(.*?)($Lval)\s*(==|\!=)\s*(true|false)\b(.*)$/i) {
> +			my $lead = $1;
> +			my $arg = $2;
> +			my $test = $3;
> +			my $otype = $4;
> +			my $trail = $5;
> +			my $type = lc($otype);
> +			my $op = "!";
> +			if (("$test" eq "==" && "$type" eq "true") ||
> +			    ("$test" eq "!=" && "$type" eq "false")) {
> +				$op = "";
> +			}
> +			WARN("BOOL_COMPARISON",
> +			     "Using comparison to $otype is poor style. Use '${lead}${op}${arg}${trail}'\n" . $herecurr);

In a complex case such as  a + b == false  will this do the right thing?
Not that I am sure that adding bools makes sense but assuming there is
some valid complex lval.

-apw

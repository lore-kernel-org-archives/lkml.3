Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626Ab3DKSq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:46:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39099 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759696Ab3DKSq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:46:56 -0400
Message-ID: <1365706015.1929.32.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Only warn for empty lines before closing
 braces by themselves
From: Joe Perches <joe@perches.com>
To: Matthijs Kooijman <matthijs@stdin.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Apr 2013 11:46:55 -0700
In-Reply-To: <20130410084927.GR13691@login.drsnuggles.stderr.nl>
References: <20130410084927.GR13691@login.drsnuggles.stderr.nl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 10:49 +0200, Matthijs Kooijman wrote:
> This check was intended to catch extra newlines at the end of a function
> definition, but it would trigger on any closing brace, including those
> of inline functions and macro definitions, triggering false positives.
> Now, only closing braces on a line by themselves trigger this check.
[]
> Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>

Acked-by: Joe Perches <joe@perches.com>

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 532c41b..f962c30 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3236,7 +3236,7 @@ sub process {
>  		}
>  
>  # check for unnecessary blank lines around braces
> -		if (($line =~ /^..*}\s*$/ && $prevline =~ /^.\s*$/)) {
> +		if (($line =~ /^.\s*}\s*$/ && $prevline =~ /^.\s*$/)) {
>  			CHK("BRACES",
>  			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
>  		}



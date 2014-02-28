Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaB1Qqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:46:34 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44994 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaB1Qqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:46:33 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187K1J15oWqRbF1OIDc0A9+FFnsI1ItykU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 186885366F2
Date: Fri, 28 Feb 2014 11:46:30 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Aaron Brown <aaron.f.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH] doc: update SubmittingPatches about the Fixed tag
Message-ID: <20140228164630.GN1872@titan.lakedaemon.net>
References: <1393558622-1392-1-git-send-email-aaron.f.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393558622-1392-1-git-send-email-aaron.f.brown@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 07:37:02PM -0800, Aaron Brown wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> This patch updates the SubmittingPatches process to include howto about
> the new 'Fixed' tag to be used when a patch fixes an issue in a previous
> commit (found by git-bisect for example).
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Aaron Brown <aaron.f.brown@intel.com>
> ---
>  Documentation/SubmittingPatches | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 26b1e31..88a796c 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -119,6 +119,13 @@ Example:
>  	platform_set_drvdata(), but left the variable "dev" unused,
>  	delete it.
>  
> +If your patch fixes a bug in a specific commit, e.g. you found an issue using
> +git-bisect, please use the 'Fixes:' tag with the first 12 characters of the
> +SHA-1 ID, and the one line summary.

It may be worth mentioning here that this can be configured in your git
config by setting core.abbrev = 12.

> +Example:
> +
> +	Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")
> +
>  
>  3) Separate your changes.
>  
> @@ -430,7 +437,7 @@ person it names.  This tag documents that potentially interested parties
>  have been included in the discussion
>  
>  
> -14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
> +14) Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
>  
>  If this patch fixes a problem reported by somebody else, consider adding a
>  Reported-by: tag to credit the reporter for their contribution.  Please
> @@ -485,6 +492,11 @@ idea was not posted in a public forum. That said, if we diligently credit our
>  idea reporters, they will, hopefully, be inspired to help us again in the
>  future.
>  
> +A Fixes: tag indicates that the patch fixes an issue in a previous commit. It
> +is used to make it easy to determine where a bug originated, which can help
> +review a bug fix. This is the preferred method for indicating a bug fixed by
> +the patch. See #2 above for more details.
> +

imho, the most useful aspect of this tag is for determining which stable
kernel versions the fix should be backported to.  Perhaps

"...review a bug fix.  This tag also assists the stable kernel team in
determining which stable kernel versions should receive your fix. This
is the preferred..."

thx,

Jason.

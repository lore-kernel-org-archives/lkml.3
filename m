Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3IBT4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 15:56:38 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49554 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3IBT4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 15:56:37 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 12:56:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        David Howells <dhowells@redhat.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] checkpatch: Add warning about submitting patches using
 --file
Message-ID: <20130902195627.GC32628@leaf>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <1378150847.1953.106.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378150847.1953.106.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 12:40:47PM -0700, Joe Perches wrote:
> Add a message describing the lack of value in using
> --file to generate patches.
> 
> Exclude files in staging from this message.
> 
> A similar message was removed by commit cf655043d4b
> ("update checkpatch.pl to version 0.15")
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
> 
> Maybe this sort of wordsmithing is valuable.
> 
>  scripts/checkpatch.pl | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 9bb056c..f788a14 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4280,6 +4280,19 @@ $vname has style problems, please review.
>  If any of these errors are false positives, please report
>  them to the maintainer, see CHECKPATCH in MAINTAINERS.
>  EOM
> +		if ($file && $realfile !~ m@\bstaging/@) {
> +			print << "EOM";
> +
> +WARNING: When using --file mode, do not send patches that just make
> +whitespace or formatting changes unless more significant changes are
> +also made for other reasons in another patch.
> +
> +Patches that are just code style changes have a real cost.
> +
> +These sort of patches can cause rejects with other changes and are
> +thought of by many maintainers as more harmful and tiresome than useful.
> +EOM
> +		}
>  	}
>  
>  	return $clean;
> 
> 

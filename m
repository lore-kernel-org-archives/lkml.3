Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3KRXaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:30:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56590 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab3KRXac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:30:32 -0500
Date: Tue, 19 Nov 2013 00:30:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH] checkpatch.pl: Check for function declarations without
 arguments
Message-ID: <20131118233028.GB27541@pd.tnic>
References: <1384813914-11491-1-git-send-email-richard@nod.at>
 <1384814182.17783.5.camel@joe-AO722>
 <1823702.CebDozRkek@sandpuppy>
 <1384816981.17783.10.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1384816981.17783.10.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 03:23:01PM -0800, Joe Perches wrote:
> Functions like this one are evil:
> 
> void foo()
> {
> 	...
> }
> 
> Because these functions allow variadic arguments without
> checking the arguments at all.
>  
> Original-patch-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 61090e0..2e1ff0c 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2634,6 +2634,15 @@ sub process {
>  				$herecurr);
>                 }
>  
> +# check for function declarations without arguments like "int foo()"
> +		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
> +			if (ERROR("FUNCTION_WITHOUT_ARGS",
> +				  "Bad function definition - $1() should probably be $1(void)\n" . $herecurr) &&

I liked the nice preaching comment better - this one is boring.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

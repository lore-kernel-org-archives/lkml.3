Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3JGTuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:50:40 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:42992 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3JGTui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:50:38 -0400
MIME-Version: 1.0
In-Reply-To: <20131007191835.GA28737@jtriplet-mobl1>
References: <20131007191835.GA28737@jtriplet-mobl1>
Date: Mon, 7 Oct 2013 21:50:37 +0200
Message-ID: <CAFLxGvwt7H+N_GTVPfxejrEk28=48EapOPXsX-=z6sygJ_YsUw@mail.gmail.com>
Subject: Re: [RFC PATCH] checkpatch: Make the 80-character limit a --strict
 check only
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        gregkh@linux-foundation.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 9:18 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> The 80-character limit is not a hard-and-fast rule, nor should it be
> applied blindly by people running checkpatch and fixing its warnings.
> Sometimes it's better to violate the 80-character "limit" in the name of
> readability, and when it isn't, it's often better to refactor into a
> function or otherwise restructure the code rather than just finding
> increasingly awkward places to break lines.
>
> Thus, change checkpatch's LONG_LINE warning to a --strict CHK instead.
> Anyone wanting to use checkpatch to check for this can easily enough
> enable --strict or turn on LONG_LINE explicitly, but it shouldn't be
> part of the default warnings.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

As I'm not a huge fan of the 80-character limit,

Acked-by: Richard Weinberger <richard@nod.at>

> ---
>
>  scripts/checkpatch.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 47016c3..ed16a68 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2017,8 +2017,8 @@ sub process {
>                     $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
>                     $length > $max_line_length)
>                 {
> -                       WARN("LONG_LINE",
> -                            "line over $max_line_length characters\n" . $herecurr);
> +                       CHK("LONG_LINE",
> +                           "line over $max_line_length characters\n" . $herecurr);
>                 }
>
>  # Check for user-visible strings broken across lines, which breaks the ability
> --
> 1.8.4.rc3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard

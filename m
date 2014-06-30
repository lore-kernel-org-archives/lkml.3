Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaF3KLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:11:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53989 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbaF3KLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:11:22 -0400
Date: Mon, 30 Jun 2014 11:11:37 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Joe Perches <joe@perches.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Enable whitespace checks for DTS files
Message-ID: <20140630101137.GA31222@bark>
References: <1404122011-11409-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404122011-11409-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 11:53:31AM +0200, Geert Uytterhoeven wrote:
> When run on *.dtsi or *.dts files, the whitespace checks were skipped,
> while they are valid for DTS files.  Hence stop skipping them.
> 
> I ran checkpatch on all in-tree DTS files, and didn't notice any error or
> warning messages that are inappropriate for DTS files.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  scripts/checkpatch.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 010b18ef4ea0..9ae624942a84 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2137,7 +2137,7 @@ sub process {
>  		}
>  
>  # check we are in a valid source file if not then ignore this hunk
> -		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
> +		next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);

I think it is this one here which lets the white space checks happen for
your new file types ...

>  #line length limit
>  		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
> @@ -2192,7 +2192,7 @@ sub process {
>  		}
>  
>  # check we are in a valid source file C or perl if not then ignore this hunk
> -		next if ($realfile !~ /\.(h|c|pl)$/);
> +		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);

... so I am supprised to see you also changing this one.  Is there a
check below here you wanted other than those stated in the patch
commentary?

>  
>  # at the beginning of a line any tabs must come first and anything
>  # more than 8 must use tabs.

-apw

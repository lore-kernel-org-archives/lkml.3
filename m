Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaCGN3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:29:51 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:45441 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbaCGN3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:29:50 -0500
Message-ID: <5319C9CA.1080604@epfl.ch>
Date: Fri, 07 Mar 2014 14:29:46 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
CC: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] checkpatch: check compatible strings in .c and
 .h too
References: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch> <1394198771-25913-4-git-send-email-florian.vaussard@epfl.ch>
In-Reply-To: <1394198771-25913-4-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/07/2014 02:26 PM, Florian Vaussard wrote:
> From: Joe Perches <joe@perches.com>
> 
> From: Joe Perches <joe@perches.com>
> 

Mmmh, sorry for this. I will resend.

> Look for ".compatible = "foo" strings not only in .dts files, but
> in .c and .h too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> [florian.vaussard@epfl.ch: split patch, commit log]
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  scripts/checkpatch.pl | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 96f10ba..9205153 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2041,8 +2041,10 @@ sub process {
>  		}
>  
>  # check for DT compatible documentation
> -		if (defined $root && $realfile =~ /\.dts/ &&
> -		    $rawline =~ /^\+\s*compatible\s*=/) {
> +		if (defined $root &&
> +			(($realfile =~ /\.dtsi?$/ && $line =~ /^\+\s*compatible\s*=\s*\"/) ||
> +			 ($realfile =~ /\.[ch]$/ && $line =~ /^\+.*\.compatible\s*=\s*\"/))) {
> +
>  			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
>  
>  			foreach my $compat (@compats) {
> 

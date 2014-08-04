Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaHDDCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:02:48 -0400
Received: from s87.loopia.se ([194.9.94.112]:20129 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaHDDCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:02:47 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <53DEF81B.1000303@hanshq.net>
Date: Sun, 03 Aug 2014 20:03:55 -0700
From: Hans Wennborg <hans@hanshq.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: Add test for printf formats with 0x that
 emit decimal
References: <1407018043-648-1-git-send-email-hans@hanshq.net>	 <1407026806.1835.21.camel@joe-AO725> <53DD8E17.1@hanshq.net>	 <1407046215.1835.24.camel@joe-AO725> <53DED2E9.5090205@hanshq.net>	 <1407112425.16152.10.camel@joe-AO725> <1407120645.16152.28.camel@joe-AO725>
In-Reply-To: <1407120645.16152.28.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2014 07:50 PM, Joe Perches wrote:
> 0x%<foo> should be used to emit hexadecimal values.
>
> Uses of 0x%[udi] emit decimal values but these should
> probably instead use 0x%x variants.
>
> Warn on these uses.

Good idea!

>
> Signed-off-by: Joe Perches <joe@perches.com>
> Noticed-by: Hans Wennborg <hans@hanshq.net>
> ---
>   scripts/checkpatch.pl | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index da74e65..0178fe0 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4985,6 +4985,10 @@ sub process {
>   		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
>   			$string = substr($rawline, $-[1], $+[1] - $-[1]);
>   			$string =~ s/%%/__/g;
> +			if ($string =~ /(0x(?<!%)%[0-9.\*]*[Ll]*[udi])(?![xX])/) {

Maybe the regex should have a \b to check for a word boundary before the 
0 to avoid matching things like "800x%d"? (I don't know if that occurs 
in the kernel, but I've seen it elsewhere.)

  - Hans

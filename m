Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3IESUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:20:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3IESUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:20:35 -0400
Message-ID: <5228CB51.6010501@infradead.org>
Date: Thu, 05 Sep 2013 11:20:01 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] kernel-doc: Update script to find more "Return:" sections
References: <1378254868.7347.40.camel@joe-AO722>
In-Reply-To: <1378254868.7347.40.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/13 17:34, Joe Perches wrote:
> Many kernel-doc return description sections headers
> use variants of the "Return:" section prefix.
> 
> (some or maybe even most of these aren't in
>  kernel-doc sections, but many are)
> 
> $ git grep -E -i "^\s*\*\s*return[s]?:"| \
>   cut -f2- -d":" | awk '{print $1 $2}' | \
>   sort | uniq -c
>     121 *return:
>     838 *Return:
>     778 *RETURN:
>     191 *returns:
>    1965 *Returns:
>     603 *RETURNS:
> 
> Rather than change all of the variants to the
> canonical "Return:", adapt the script to accept
> case insensitive "Return:" and "Returns:"
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> I don't know that this actually works.
> It does seem right though.
> 
> Randy?  Rob?  Can you test this please?

Works for me.  Thanks.

Tested-by: Randy Dunlap <rdunlap@infradead.org>


> 
>  scripts/kernel-doc | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 4305b2f..2b96411 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -418,6 +418,7 @@ sub dump_section {
>  	$parameterdescs{$name} = $contents;
>  	$sectcheck = $sectcheck . $name . " ";
>      } else {
> +	$name = "Return" if $name =~ /^return[s]?$/i;
>  #	print STDERR "other section '$name' = '$contents'\n";
>  	if (defined($sections{$name}) && ($sections{$name} ne "")) {
>  		print STDERR "Error(${file}:$.): duplicate section name '$name'\n";
> 
> 
> --



-- 
~Randy

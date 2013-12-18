Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3LRRnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:43:20 -0500
Received: from [65.182.180.190] ([65.182.180.190]:55340 "EHLO
	mxadeneo.adeneo-embedded.us" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755558Ab3LRRnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:43:16 -0500
Message-ID: <52B1DEAC.40901@adeneo-embedded.us>
Date: Wed, 18 Dec 2013 09:43:08 -0800
From: Jean-Baptiste Theou <jtheou@adeneo-embedded.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch.pl: Fix wrong curly bracket position reporting
References: <1387335591-8741-1-git-send-email-jtheou@adeneo-embedded.us> <1387345186.13593.7.camel@joe-AO722>
In-Reply-To: <1387345186.13593.7.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.20.56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Looks good to me, it fix this issue and for sure more global.

Regards,

Jean-Baptiste
On 12/17/2013 09:39 PM, Joe Perches wrote:
> On Tue, 2013-12-17 at 18:59 -0800, Jean-Baptiste Theou wrote:
>> This patch fixes wrong curly bracket position reporting when function
>> declarations have only one void argument.
>>
>> Missing error (ERROR: space required before the open brace '{') on this
>> situation :
>>
>> int foo(void){
>> 	...
>> }
> That's true for any declaration with { on the same line.
>
> Perhaps this would be better:
> ---
>   scripts/checkpatch.pl | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 8f3aecd..c4dbb8a 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2784,7 +2784,8 @@ sub process {
>   
>   # function brace can't be on same line, except for #defines of do while,
>   # or if closed on same line
> -		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
> +		if ($^V && $^V ge 5.10.0 &&
> +		    ($line=~/$Type\s*$Ident\s*$balanced_parens\s*{\s*$/) &&
>   		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
>   			ERROR("OPEN_BRACE",
>   			      "open brace '{' following function declarations go on the next line\n" . $herecurr);
> @@ -3159,7 +3160,9 @@ sub process {
>   ## 		}
>   
>   #need space before brace following if, while, etc
> -		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
> +		if ($^V && $^V ge 5.10.0 &&
> +		    ($line !~ /$Type\s*$Ident\s*$balanced_parens\s*{\s*$/) &&
> +		    ($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
>   		    $line =~ /do{/) {
>   			if (ERROR("SPACING",
>   				  "space required before the open brace '{'\n" . $herecurr) &&
>
>


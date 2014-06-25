Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbaFYO0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:26:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:38447 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaFYO0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:26:32 -0400
Message-ID: <53AADC30.7080401@windriver.com>
Date: Wed, 25 Jun 2014 10:26:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/mod/modpost.c: Fix bug in number_prefix
References: <1403685999-31013-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1403685999-31013-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-06-25 04:46 AM, Rasmus Villemoes wrote:
> The function number_prefix() can currently only return 1 if its
> argument is the empty string: If line 3 is reached and *sym (now the
> second character in the argument) is not '.', 0 is returned. However,
> if that character is '.', the first assignment to c is that same '.',
> which obviously fails to be a digit.

I'd suggest you expand the commit log to actually list the end-user
visible symptom and the use case that this actually fixes, since it
isn't obvious to me at all.

Thanks,
Paul.
--

> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  scripts/mod/modpost.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 9d9c5b9..336f45f 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -778,9 +778,9 @@ static const char *sech_name(struct elf_info *elf, Elf_Shdr *sechdr)
>   */
>  static int number_prefix(const char *sym)
>  {
> -	if (*sym++ == '\0')
> +	if (*sym == '\0')
>  		return 1;
> -	if (*sym != '.')
> +	if (*sym++ != '.')
>  		return 0;
>  	do {
>  		char c = *sym++;
> 

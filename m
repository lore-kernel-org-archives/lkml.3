Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3KRSGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:06:33 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:60882 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KRSGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:06:25 -0500
Date: Mon, 18 Nov 2013 19:06:19 +0100
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Clement Chauplannaz <chauplac@gmail.com>
Cc: linux-kbuild@vger.kernel.org, mmarek@suse.cz, sedat.dilek@gmail.com,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/config: allow setting a string which value
 contains a colon
Message-ID: <20131118180619.GA3458@free.fr>
References: <1384689334-6979-1-git-send-email-chauplac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1384689334-6979-1-git-send-email-chauplac@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clément, All,

On 2013-11-17 12:55 +0100, Clement Chauplannaz spake thusly:
> A bug in script `config' prevented from modifying an existing variable's
> value to a string that contains a colon ':'.  The reason behind it is that
> colons are used as a separator in `sed' commands that script `config'
> relies on.
> 
> Escape colons in `sed' commands to allow values containing colons.
> 
> Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>

Acked-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

It'll be in my tree soon, as a rc-fix. Thank you.

Regards,
Yann E. MORIN.

> ---
>  scripts/config | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/config b/scripts/config
> index 6804179..4b16260 100755
> --- a/scripts/config
> +++ b/scripts/config
> @@ -78,7 +78,7 @@ txt_append() {
>  
>  txt_subst() {
>  	local before="$1"
> -	local after="$2"
> +	local after="${2//:/\:}"
>  	local infile="$3"
>  	local tmpfile="$infile.swp"
>  
> -- 
> 1.8.3.2.dirty
> 

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

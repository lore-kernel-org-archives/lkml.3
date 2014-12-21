Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaLUK1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 05:27:43 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:53626 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaLUK1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 05:27:41 -0500
Message-ID: <54969F9A.80301@ahsoftware.de>
Date: Sun, 21 Dec 2014 11:23:22 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] CodingStyle: remove what nowadays might be considered
 polemic
References: <1418996188-2908-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1418996188-2908-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.12.2014 um 14:36 schrieb Alexander Holler:
> In times where things like checkpatch do exist and are mandated to be used,
> it would be easy to warn if too many levels of indentation are used (e.g.
> by counting leading tabs).
>
> The paragraph before already says that more than 3 levels of indentation
> are bad, so the (removed) sentence nowadays only smells like an additional
> excuse or polemic (because you still could use an unholy number of e.g.
> 7 indentations, even within the limit of 80 chars).
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>   Documentation/CodingStyle | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 618a33c..8e96b14 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -31,10 +31,6 @@ the code move too far to the right, and makes it hard to read on a
>   more than 3 levels of indentation, you're screwed anyway, and should fix
>   your program.
>
> -In short, 8-char indents make things easier to read, and have the added
> -benefit of warning you when you're nesting your functions too deep.
> -Heed that warning.
> -

As I've become curious how many time the kernels source is already 
screwed, I did some quick and simple stats on 3.18:

find /tmp/linux/ -name '*.c' -exec grep -P "^\t+return " {} \; | sed -e 
's/^\(\t\+\).*/\1/' | wc -L
72

Uups, there is maximum of 8 levels of intendation (not 9, the first tab 
isn't really an intendation as it's the leading tab of every code inside 
a function). Quiet the maximum which is possible with the 80 character 
limit. This made me even more curious, so I did:

[aholler@krabat ~]$ for i in $(seq 1 9); do echo -n "$i tabs: "; find 
/tmp/linux/ -name '*.c' -exec grep -P "^(\t){$i}return " {} \; | wc -l; done
1 tabs: 233866
2 tabs: 189497
3 tabs: 45874
4 tabs: 9473
5 tabs: 1738
6 tabs: 249
7 tabs: 51
8 tabs: 15
9 tabs: 5



That means the kernels source is already screwed at at least 2058 places 
And regarding that I've searched only for "<tab>return " this should be 
enough proof, that the limit of 80 chars doesn't really help in regard 
to levels of intendation.

Regards,

Alexander Holler

PS: Please don't start a discussion about the regexp I've used (if they 
aren't wrong). They are a result of 10 minutes and are not the topic of 
this mail (TIMTOWTDI).

PPS: If you are curious why I've spend the time to built and sent that 
silly patch: I've heared that wrong argument that a maximum line length 
of 80 chars helps in regard to keep the levels of intendation low once 
too often. And the source was much likely always the kernels CodingStyle 
document.


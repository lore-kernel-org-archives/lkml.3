Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaJJNBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:01:49 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:59067 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbaJJNBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:01:47 -0400
Message-ID: <1412946102.2037.13.camel@x220>
Subject: Re: [PATCH v2 2/2] kconfig: trivial - adjust comments
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Walch <walch.martin@web.de>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 10 Oct 2014 15:01:42 +0200
In-Reply-To: <1411405999-20212-3-git-send-email-walch.martin@web.de>
References: <3491939.FtiyjGE4Of@tacticalops>
	 <1411405999-20212-1-git-send-email-walch.martin@web.de>
	 <1411405999-20212-3-git-send-email-walch.martin@web.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Oct 2014 13:01:42.0608 (UTC) FILETIME=[56924500:01CFE48A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

I haven't yet dared to review 1/2, which is the interesting change. So I
cheated and skipped to 2/2.

On Mon, 2014-09-22 at 19:13 +0200, Martin Walch wrote:
> Replace any C99 comments with traditional ones (/*...*/).

Perhaps you could split those changes off in a separate, trivial patch.

> Also fix the contents of two comments:
> 
> 1) the second occurrence of
> (a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b'
> is probably copy & paste from above, missing the adjustment corresponding
> to the code.
> It should probably read
> (a!='b') && (a='c') -> 'b'='c' ? 'n' : a='c'
> 
> 2) that one is similar:
> (a!='m') && (a!='n') -> (a='m')
> it should be
> (a!='m') && (a!='n') -> (a='y')

And perhaps even send these two changes as two separate patches. Not
sure, as I don't review much, but it should make it easier to review.

> Signed-off-by: Martin Walch <walch.martin@web.de>
> ---
>  scripts/kconfig/expr.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
> index 4aa171b..c840e52 100644
> --- a/scripts/kconfig/expr.c
> +++ b/scripts/kconfig/expr.c
> [...] 
>  	if (sym1->type == S_TRISTATE) {
>  		if (e1->type == E_EQUAL && e2->type == E_UNEQUAL) {
> -			// (a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b'
> +			/* (a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b' */

Could you make this match the code? Ie,
                         /* (a='b') && (a!='c') -> 'b'!='c' ? a='b' : 'n' */

if I'm reading the code right.

>  			sym2 = e1->right.sym;
>  			if ((e2->right.sym->flags & SYMBOL_CONST) && (sym2->flags & SYMBOL_CONST))
>  				return sym2 != e2->right.sym ? expr_alloc_comp(E_EQUAL, sym1, sym2)
>  							     : expr_alloc_symbol(&symbol_no);
>  		}
>  		if (e1->type == E_UNEQUAL && e2->type == E_EQUAL) {
> -			// (a='b') && (a!='c') -> 'b'='c' ? 'n' : a='b'
> +			/* (a!='b') && (a='c') -> 'b'='c' ? 'n' : a='c' */

Likewise:
                         /* (a!='b') && (a='c') -> 'b'!='c' ? a='c' : 'n' */

>  			sym2 = e2->right.sym;
>  			if ((e1->right.sym->flags & SYMBOL_CONST) && (sym2->flags & SYMBOL_CONST))
>  				return sym2 != e1->right.sym ? expr_alloc_comp(E_EQUAL, sym1, sym2)

(You could also make the code match the comments. But that would make
the patch less trivial.)


Paul Bolle


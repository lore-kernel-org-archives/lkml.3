Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3GHCWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 22:22:17 -0400
Received: from ozlabs.org ([203.10.76.45]:47938 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab3GHCWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:22:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Wedson Almeida Filho <wedsonaf@gmail.com>,
        Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org, Wedson Almeida Filho <wedsonaf@gmail.com>
Subject: Re: [PATCH] lib: One less subtraction in binary search iterations.
In-Reply-To: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com>
References: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 08 Jul 2013 11:16:41 +0930
Message-ID: <87txk5esce.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wedson Almeida Filho <wedsonaf@gmail.com> writes:
> There is no functional change, but this change eliminates a subtraction that
> the compiler doesn't optimize out (as of gcc 4.7.3).
>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> ---
>  lib/bsearch.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/bsearch.c b/lib/bsearch.c
> index e33c179..3264146 100644
> --- a/lib/bsearch.c
> +++ b/lib/bsearch.c
> @@ -37,7 +37,7 @@ void *bsearch(const void *key, const void *base, size_t num, size_t size,
>  	int result;
>  
>  	while (start < end) {
> -		size_t mid = start + (end - start) / 2;
> +		size_t mid = (start + end) / 2;
>  
>  		result = cmp(key, base + mid * size);
>  		if (result < 0)
> -- 
> 1.7.9.5

Please add a comment about overflow instead?

Thanks,
Rusty.

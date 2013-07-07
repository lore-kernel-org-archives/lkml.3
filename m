Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3GGE7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 00:59:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57553 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802Ab3GGE7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 00:59:31 -0400
Message-ID: <1373173169.1943.1.camel@joe-AO722>
Subject: Re: [PATCH] lib: One less subtraction in binary search iterations.
From: Joe Perches <joe@perches.com>
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 06 Jul 2013 21:59:29 -0700
In-Reply-To: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com>
References: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-06 at 16:07 -0700, Wedson Almeida Filho wrote:
> There is no functional change, but this change eliminates a subtraction that
> the compiler doesn't optimize out (as of gcc 4.7.3).

Not correct.

> diff --git a/lib/bsearch.c b/lib/bsearch.c
[]
> @@ -37,7 +37,7 @@ void *bsearch(const void *key, const void *base, size_t num, size_t size,
>  	int result;
>  
>  	while (start < end) {
> -		size_t mid = start + (end - start) / 2;
> +		size_t mid = (start + end) / 2;

	size_t start = 0x80000000;
	size_t end   = 0x80000001;



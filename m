Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaKVDgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 22:36:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34193 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaKVDgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 22:36:41 -0500
Date: Sat, 22 Nov 2014 03:36:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [RFC] situation with csum_and_copy_... API
Message-ID: <20141122033639.GY7996@ZenIV.linux.org.uk>
References: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
 <20141119.161744.1661940121298888832.davem@davemloft.net>
 <20141119213006.GE7996@ZenIV.linux.org.uk>
 <20141119.165340.2162829993279387495.davem@davemloft.net>
 <20141120214753.GR7996@ZenIV.linux.org.uk>
 <1416520542.8629.46.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141120222506.GS7996@ZenIV.linux.org.uk>
 <1416524035.8629.54.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141121084956.GT7996@ZenIV.linux.org.uk>
 <20141122032718.GA24457@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141122032718.GA24457@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 03:27:18AM +0000, Al Viro wrote:
  
> @@ -566,38 +445,15 @@ static size_t copy_to_iter_bvec(void *from, size_t bytes, struct iov_iter *i)
[snip]
> +	iterate_bvec(i, bytes, page, off, len, true,
> +		     memcpy_from_page((from += len) - len, page, off, len))

should be
+		     memcpy_to_page(page, off, (from += len) - len, len))

and

> @@ -605,35 +461,9 @@ static size_t copy_from_iter_bvec(void *to, size_t bytes, struct iov_iter *i)
[snip]
> +	iterate_bvec(i, bytes, page, off, len, true,
> +		     memcpy_to_page(page, off, (to += len) - len, len))

should be
+		     memcpy_from_page((to += len) - len, page, off, len))

Sorry, wrong delta.

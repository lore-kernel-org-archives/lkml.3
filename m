Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3HEQIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:08:31 -0400
Received: from kanga.kvack.org ([205.233.56.17]:33049 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab3HEQI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:08:29 -0400
Date: Mon, 5 Aug 2013 12:08:28 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: koverstreet@google.com, axboe@kernel.dk,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        linux-aio@kvack.org, trinity@vger.kernel.org
Subject: Re: aio: kernel BUG at fs/aio.c:646!
Message-ID: <20130805160828.GH31864@kvack.org>
References: <51FFAF34.20200@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FFAF34.20200@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On Mon, Aug 05, 2013 at 09:57:08AM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next 
> kernel,
> I've stumbled on the following spew caused by a new BUG() added in "aio: fix
> io_destroy() regression by using call_rcu()".

I did some investigating, and it looks like there is a problem with 
db446a08c23d5475e6b08c87acca79ebb20f283c (aio: convert the ioctx list to 
table lookup v3).  Can you confirm if reverting this patch eliminates 
the BUG() you're hitting?  In my testing, I wasn't able to trigger the 
BUG(), but I was able to trip up slab corruption with debugging on.  
Thanks,

		-ben

...
> Thanks,
> Sasha

-- 
"Thought is the essence of where you are now."

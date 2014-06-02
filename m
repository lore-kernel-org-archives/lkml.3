Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaFBQEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:04:41 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49265 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaFBQEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:04:40 -0400
Message-ID: <538CA095.809@kernel.dk>
Date: Mon, 02 Jun 2014 10:04:37 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] block: Eliminate first argument of submit_bio()
References: <538C4767.5050207@acm.org>
In-Reply-To: <538C4767.5050207@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-02 03:44, Bart Van Assche wrote:
> The submit_bio() API is confusing. Merge functions like
> raid5_mergeable_bvec() can only work correctly if bi_rw is set
> before bio_add_page() has been called. submit_bio() modifies
> bi_rw after bio_add_page() has been called. Hence remove the
> first argument of submit_bio() and let the caller set bi_rw.
> Note: some but not all submit_bio() callers have been fixed
> such that bi_rw is set before bio_add_page() is called.
>
> See also http://thread.gmane.org/gmane.comp.file-systems.ocfs2.devel/7988
> for a prior discussion of this topic.
>
> Compile tested only, hence the "RFC".

It's a good cleanup, makes the API harder to misuse. The fact that rw 
needs to be set before add_page() was a later addition, and we've 
suffered from that.

Will need some testing, but after that should be good for 3.17.

-- 
Jens Axboe


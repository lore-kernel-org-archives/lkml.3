Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbbANKR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:17:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40583 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbbANKR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:17:27 -0500
MIME-Version: 1.0
In-Reply-To: <20150113162307.GA21338@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
	<20150113162307.GA21338@infradead.org>
Date: Wed, 14 Jan 2015 18:17:24 +0800
Message-ID: <CACVXFVOioFRNbDBJtBaG6za3gq01FdThQsocS42Ecd5UR5X0pg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] block & aio: improve loop with kernel aio
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Zach Brown <zab@zabbo.net>, Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 12:23 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 13, 2015 at 11:44:44PM +0800, Ming Lei wrote:
>> Follows benefits from using kernel aio in loop:
>>       - avoid double cache, and memory usage decreased a lot
>>       - system load gets much decreased
>
> This seems to conflate two changes:
>
>  1) use direct I/O
>  2) use aio (require 1)
>
> what numbers do you get when just using direct I/O?

I don't run the direct I/O only test because it needs quite
changes on current patches, such as: make the kiocb
as sync, allow all dio requests running concurrently for
sake of throughput.

IMO, without aio, context switches will be increased
inevitably, and CPU will be wasted, so could you explain
if there is advantage of not using aio?

Thanks,
Ming Lei

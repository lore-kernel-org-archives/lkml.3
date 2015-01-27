Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbbA0F06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 00:26:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33001 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbbA0F04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 00:26:56 -0500
MIME-Version: 1.0
In-Reply-To: <20150125133514.GC19445@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
	<1421163888-21452-4-git-send-email-ming.lei@canonical.com>
	<20150125133514.GC19445@infradead.org>
Date: Tue, 27 Jan 2015 13:26:54 +0800
Message-ID: <CACVXFVOgMvccTUZB91OZFgjc_zQk0VnhxtBTO0OhwRYBye8Xnw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] block: loop: introduce 'use_aio' sysfs file
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/15, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 13, 2015 at 11:44:47PM +0800, Ming Lei wrote:
>> So that users can control if kernel aio is used to submit I/O.
>
> Why do you want a sysfs flag for this instead of a flags in ->lo_flags
> at setup time?  That's how all other loop-related ABI flags work.

The flag only effects performance or CPU/memory resource utilization,
and I plan to change it as dio flag.

On Tue, Jan 27, 2015 at 1:57 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Ming Lei <ming.lei@canonical.com> writes:
>
>> So that users can control if kernel aio is used to submit I/O.
>
> How would a user know to choose aio or, um, /not/ aio?  At the very
> least, documentation is required for this.  I'd rather see the option
> disappear completely, though.

As the comment says in patch 4/4, using direct I/O can save memory/CPU
a lot, and won't hurt throughput if I/O is from filesystem. Otherwise,
user may choose to not use direct I/O for sake of throughput.


Thanks,
Ming Lei

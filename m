Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbbA0N5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:57:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35974 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbbA0N5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:57:49 -0500
MIME-Version: 1.0
In-Reply-To: <20150126170048.GA2080@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
	<1421163888-21452-2-git-send-email-ming.lei@canonical.com>
	<20150125133147.GA19445@infradead.org>
	<CACVXFVOzjroTqcgduqvKzcDVvNvO4xGX6go3+ZspfQkz3_2zAQ@mail.gmail.com>
	<20150126170048.GA2080@infradead.org>
Date: Tue, 27 Jan 2015 21:57:47 +0800
Message-ID: <CACVXFVNLQegYD2RHO9EVCVNcYE0hgn5xXXJPRud9kM8zaCYNGQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] aio: add aio_kernel_() interface
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Zach Brown <zab@zabbo.net>, Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "open list:AIO" <linux-aio@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 1:00 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 27, 2015 at 12:18:23AM +0800, Ming Lei wrote:
>> > Also it might make sense to just offer aio_kernel_read/write intefaces
>> > instead of the common submit wrapper, as that's much closer to other
>> > kernel APIs, e.g.
>> >
>> > int aio_kernel_read(struct kiocb *iocb, struct file *file,
>> >                 struct iov_iter *iter, loff_t off,
>> >                 void (*complete)(struct kiocb *iocb, long res));
>> > int aio_kernel_write(struct kiocb *iocb, struct file *file,
>> >                 struct iov_iter *iter, loff_t off,
>> >                 void (*complete)(struct kiocb *iocb, long res));
>>
>> It is like style of sync APIs, looks submit/complete is common
>> for async APIs, like io_submit().
>
> io_submit is a fairly horrible API.  While Posix AIO isn't too much
> better it does have separate APIs for read/write.  Given that there
> isn't much code shared I'd keep an API that feels familar.

But from performance view, the two APIs of aio_kernel_read()
and aio_kernel_write() aren't good because both need
5 parameters which can't be held in registers and they are
often called from single thread context, not like synchronized
read() and write().

Also aio_kernel_init_rw() can be moved to header file as inline
to avoid too many parameters.

Thanks,
Ming Lei

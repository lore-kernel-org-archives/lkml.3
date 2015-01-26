Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbbAZRAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:00:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53587 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbbAZRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:00:48 -0500
Date: Mon, 26 Jan 2015 09:00:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Zach Brown <zab@zabbo.net>, Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "open list:AIO" <linux-aio@kvack.org>
Subject: Re: [PATCH v2 1/4] aio: add aio_kernel_() interface
Message-ID: <20150126170048.GA2080@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
 <1421163888-21452-2-git-send-email-ming.lei@canonical.com>
 <20150125133147.GA19445@infradead.org>
 <CACVXFVOzjroTqcgduqvKzcDVvNvO4xGX6go3+ZspfQkz3_2zAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOzjroTqcgduqvKzcDVvNvO4xGX6go3+ZspfQkz3_2zAQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 12:18:23AM +0800, Ming Lei wrote:
> > Also it might make sense to just offer aio_kernel_read/write intefaces
> > instead of the common submit wrapper, as that's much closer to other
> > kernel APIs, e.g.
> >
> > int aio_kernel_read(struct kiocb *iocb, struct file *file,
> >                 struct iov_iter *iter, loff_t off,
> >                 void (*complete)(struct kiocb *iocb, long res));
> > int aio_kernel_write(struct kiocb *iocb, struct file *file,
> >                 struct iov_iter *iter, loff_t off,
> >                 void (*complete)(struct kiocb *iocb, long res));
> 
> It is like style of sync APIs, looks submit/complete is common
> for async APIs, like io_submit().

io_submit is a fairly horrible API.  While Posix AIO isn't too much
better it does have separate APIs for read/write.  Given that there
isn't much code shared I'd keep an API that feels familar.


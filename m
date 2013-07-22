Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3GVDBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 23:01:40 -0400
Received: from ozlabs.org ([203.10.76.45]:33206 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab3GVDBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 23:01:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: monstr@monstr.eu, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: scatterlist: sg_set_buf() argument must be in linear mapping (sha1: ac4e97abce9b80c020e7113325f49e58b7b15e3f)
In-Reply-To: <51E64C6B.3080306@monstr.eu>
References: <51E64C6B.3080306@monstr.eu>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Jul 2013 11:17:40 +0930
Message-ID: <87siz7xt4z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek <monstr@monstr.eu> writes:
> Hi Rusty and Jens,
>
> I am getting problem with your patch which you have added to the kernel.
> The problem is with my arm zynq remoteproc driver where
> I use dma_declare_coherent_memory() to specify memory for remoteproc
> which is ioremap to the vmalloc area.
>
> Based on that buf addr is not inside ram even this coherent memory is in ram.
> That's why virt_addr_valid(buf) is failing.

But sg_set_buf() calls virt_to_page(buf).  So does that work?

I would think calling sg_set_page() directly would be what you want
here...

Cheers,
Rusty.

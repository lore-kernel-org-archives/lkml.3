Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbaGWXQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:16:05 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:39759 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370AbaGWXQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:16:00 -0400
Date: Wed, 23 Jul 2014 16:16:00 -0700
From: Zach Brown <zab@zabbo.net>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, "open list:AIO" <linux-aio@kvack.org>
Subject: Re: [PATCH 7/9] aio: add aio_kernel_() interface
Message-ID: <20140723231600.GE17798@lenny.home.zabbo.net>
References: <1406156130-15575-1-git-send-email-ming.lei@canonical.com>
 <1406156130-15575-8-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406156130-15575-8-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 06:55:28AM +0800, Ming Lei wrote:
> From: Dave Kleikamp <dave.kleikamp@oracle.com>
> 
> This adds an interface that lets kernel callers submit aio iocbs without
> going through the user space syscalls.  This lets kernel callers avoid
> the management limits and overhead of the context.  It will also let us
> integrate aio operations with other kernel apis that the user space
> interface doesn't have access to.
> 
> This patch is based on Dave's posts in below links:
> 
> 	https://lkml.org/lkml/2013/10/16/365
> 	https://groups.google.com/forum/#!topic/linux.kernel/l7mogGJZoKQ

This was originally written a billion years ago when dinosaurs roamed
the earth.  Also, notably, before Kent and Ben reworked a bunch of the
aio core.  I'd want them to take a look at this patch to make sure that
it doesn't rely on any assumptions that have changed.

> +/* opcode values not exposed to user space */
> +enum {
> +	IOCB_CMD_READ_ITER = 0x10000,
> +	IOCB_CMD_WRITE_ITER = 0x10001,
> +};

And I think the consensus was that this isn't good enough.  Find a way
to encode the kernel caller ops without polluting the uiocb cmd name
space.

(I've now come to think that this entire approach of having loop use aio
is misguided and that the way forward is to have dio consume what loop
naturally produces -- bios, blk-mq rqs, whatever -- but I'm on to other
things these days.)

- z

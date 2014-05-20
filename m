Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaETCKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:10:08 -0400
Received: from ozlabs.org ([103.22.144.67]:47856 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaETCKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:10:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] module: static checker complains about negative values
In-Reply-To: <20140519203626.GC5671@mwanda>
References: <20140519203626.GC5671@mwanda>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 May 2014 11:16:04 +0930
Message-ID: <87y4xxi5nn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> We cap "stat.size" at INT_MAX but we don't check for negative values so
> my static checker complains.  At this point, you already have control of
> the kernel and if you start passing negative values here then you
> deserve what happens next.
>
> On 64 bit systems the vmalloc() will definitely fail.  On 32 bit systems
> we truncate the upper 32 bits away so that could succeed.  I haven't
> followed it further than that.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

If vfs_getattr() returns a negative stat.size, we have worse problems.

I'd rather see you sprinkle assertions like that into the code, so we
can make sure that can't happen for any fs's getattr().

Cheers,
Rusty.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3CZWvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:51:24 -0400
Received: from ozlabs.org ([203.10.76.45]:46023 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab3CZWvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:51:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andru Gheorghiu <gheorghiuandru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] drivers: virtio: Use PTR_RET function
In-Reply-To: <CADca43+r4kPBv-=kqo5VZ4+E2-OD1Y6ipkPXzxmFwrt2x1Z7Vw@mail.gmail.com>
References: <1364217936-6284-1-git-send-email-gheorghiuandru@gmail.com> <87fvzidenm.fsf@rustcorp.com.au> <20130325220150.af9795a7.akpm@linux-foundation.org> <CADca43+r4kPBv-=kqo5VZ4+E2-OD1Y6ipkPXzxmFwrt2x1Z7Vw@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 26 Mar 2013 20:53:27 +1030
Message-ID: <87620ecvds.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andru Gheorghiu <gheorghiuandru@gmail.com> writes:
> PTR_RET does return. It's perfectly equivalent to using IS_ERR and the
> returning PTR_ERR. The implementation is here [1].

Um, I read the implementation, thanks.

> The reason for using it is this: if you have a function that does
> something why not call it instead of reproducing it's behavior by
> explicitly writing what it does.

Because clarity matters, and this function makes callers less clear.
It's the most breathtakingly bad name since BUILD_BUG_ON_ZERO().

Why not change PTR_ERR to return 0 if !IS_ERR()?  Noone breaks, gcc
probably produces the same code, and noone needs to learn your weird
new kernel meme.

In fact, as gcc will produce the same code for "if (PTR_ERR(p))" as it
does for "if (IS_ERR(p))", you get to be one of the very, very few
people who have ever *reduced* the complexity of a kernel interface.

Cheers,
Rusty.

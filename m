Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3G3Fy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:54:27 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63117 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab3G3FyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:54:25 -0400
Date: Mon, 29 Jul 2013 22:54:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: dmi p <d3vp0ll@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: write(2) and page cache
In-Reply-To: <CALHgxMEtcdkmrwnu8+mAhUOAMQz7B3V7J01sChF7x3-QQsRcBw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1307292242380.9718@eggly.anvils>
References: <CALHgxMEtcdkmrwnu8+mAhUOAMQz7B3V7J01sChF7x3-QQsRcBw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jul 2013, dmi p wrote:
> Hi,
> When I write(2) on a file such that the size of the buffer being
> written is less than the page size, and the page is not in the page
> cache, does the write syscall block until the page is brought into the
> page cache from disk (to modify it and eventually write back),

Yes (except perhaps when overwriting that part of page at end of file:
I expect some filesystems might optimize out that read, and others not).

> or is the page reading part async with respect to write?

No, that would involve another layer of buffering, which I think
would be too hard to synchronize with page cache and mmap.

Hugh

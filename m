Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaBCTej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:34:39 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:39925 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaBCTeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:34:37 -0500
MIME-Version: 1.0
In-Reply-To: <52EF64CE.90506@ladisch.de>
References: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
	<52EF64CE.90506@ladisch.de>
Date: Mon, 3 Feb 2014 11:34:36 -0800
Message-ID: <CAJ3m7BohjBxGE4UmjEibhB0ndv+9sK6A-C8y3JiHWHUdFtEhwQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] epoll: read(),write(),ioctl() interface
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/14, Clemens Ladisch <clemens@ladisch.de> wrote:
> Nathaniel Yazdani wrote:
>> Using the normal I/O interface to manipulate eventpolls is much neater
>> than using epoll-specific syscalls
>
> But it introduces a _second_ API, which is epoll-specific too, and does
> not use the standard semantics either.
>
>> while also allowing for greater flexibility (theoretically, pipes could
>> be used to filter access).
>
> I do not understand this.

The idea here was that if epoll is controlled by read()/write(), then
a program could be written so that it expects the epoll to dup()ed
to a second file descriptor, using one exclusively for writing & the
other exclusively for reading. That way, if an application is in
debug mode, for example, it could start up a thread to replace
those two file descriptors with pipes, so that thread would then
be able to tee, preprocess, or do whatever else to the epoll
streams.

>> read() simply waits for enough events to fill the provided buffer.
>
> The usual semantics of read() are to return a partially filled buffer if
> it would block otherwise, i.e., blocking is done only if the returned
> buffer would have been empty.
>
>> As timeout control is essential for polling to be practical, ioctl() is
>> used to configure an optional timeout
>
> This is what the timeout parameter of poll() and friends is for.

I admit that part of this approach isn't the best.

Either way I appreciate your feedback,
Nathaniel Yazdani

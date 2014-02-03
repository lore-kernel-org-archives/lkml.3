Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaBCTde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:33:34 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37765 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBCTdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:33:33 -0500
Message-ID: <52EFEF0A.9080101@amacapital.net>
Date: Mon, 03 Feb 2014 11:33:30 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>, viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] epoll: read(),write(),ioctl() interface
References: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
In-Reply-To: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2014 06:17 PM, Nathaniel Yazdani wrote:
> Hi everyone,
> 
> This patch series adds support for read(), write(), and ioctl() operations
> on eventpolls as well as an associated userspace structure to format the
> eventpoll entries delivered via read()/write() buffers. The new structure,
> struct epoll, differs from struct epoll_event mainly in that it also holds
> the associated file descriptor. Using the normal I/O interface to manipulate
> eventpolls is much neater than using epoll-specific syscalls while also
> allowing for greater flexibility (theoretically, pipes could be used to
> filter access). Specifically, write() creates, modifies, and/or removes event
> entries stored in the supplied buffer, using the userspace identifier to
> check whether an entry exists and removing it if no events are set to trigger
> it, while read() simply waits for enough events to fill the provided buffer.
> As timeout control is essential for polling to be practical, ioctl() is used
> to configure an optional timeout, which is infinite by default.

If major changes are made to the epoll API, I want a way to do a bunch
of EPOLL_CTL_MODs and a wait, all in one syscall.  Even better: allow
more flexible timeouts (CLOCK_MONOTONIC, CLOCK_REALTIME, etc) at the
same time.

Since this can't do that, I'm not terribly inspired.

--Andy

> 
>  Documentation/ioctl/ioctl-number.txt |   1 +
>  fs/eventpoll.c                       | 534 ++++++++++++++++++++++++-----------
>  include/uapi/linux/eventpoll.h       |  10 +
>  3 files changed, 384 insertions(+), 161 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


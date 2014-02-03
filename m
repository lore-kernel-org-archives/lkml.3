Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaBCJnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:43:51 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:35910 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbaBCJns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:43:48 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <52EF64CE.90506@ladisch.de>
Date: Mon, 03 Feb 2014 10:43:42 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>, viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] epoll: read(),write(),ioctl() interface
References: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
In-Reply-To: <1391393832-8754-1-git-send-email-n1ght.4nd.d4y@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathaniel Yazdani wrote:
> Using the normal I/O interface to manipulate eventpolls is much neater
> than using epoll-specific syscalls

But it introduces a _second_ API, which is epoll-specific too, and does
not use the standard semantics either.

> while also allowing for greater flexibility (theoretically, pipes could
> be used to filter access).

I do not understand this.

> read() simply waits for enough events to fill the provided buffer.

The usual semantics of read() are to return a partially filled buffer if
it would block otherwise, i.e., blocking is done only if the returned
buffer would have been empty.

> As timeout control is essential for polling to be practical, ioctl() is
> used to configure an optional timeout

This is what the timeout parameter of poll() and friends is for.


Regards,
Clemens

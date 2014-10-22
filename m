Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaJVPcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:32:03 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:37804 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaJVPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:32:00 -0400
Date: Wed, 22 Oct 2014 16:31:46 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH -next 00/27] tty locking changes
Message-ID: <20141022163146.73967b1e@alan.etchedpixels.co.uk>
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 16:24:58 -0400
Peter Hurley <peter@hurleysoftware.com> wrote:

> Hi Greg,
> 
> This patch series has 3 major changes to how tty locking behaves:
> 1. the lock order of tty_lock() and tty->ldisc_sem is reversed;
>    this eliminates a bunch of lock drop/reacquire which, in turn,
>    eliminates tty state tracking that can no longer be observed.
>    This also allows the pty driver to wait for input processing to
>    complete while closing before setting TTY_OTHER_CLOSED (which
>    eliminates the ugliness of checking input twice in n_tty_read() and
>    n_tty_poll()).
> 2. the footprint of tty_mutex is reduced to only adding and removing
>    ttys and is no longer held to acquire the tty_lock() in tty_open();
>    this allows for multiple ttys to be opened concurrently, even if
>    one open stalls waiting for its tty_lock().
> 3. pty pair locking is reordered to master first, then slave, rather
>    than by address. This works because, while releasing the master pty,
>    the slave tty count needs to be changed, whereas, when releasing the
>    slave, the master pty does not need to be accessed.
>    This furthur eliminates more lock drop/reacquire.
> 
> The longer-term goals, which this series builds towards, is:
> 1. simplifying the tty open/close behavior
> 2. eliminating the ASYNC_CLOSING code without breaking existing userspace
> 3. eliminating returning -EIO from tty_open(). Not sure if this is possible yet.


Reviewed-by: Alan Cox <alan@linux.intel.com>


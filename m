Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaJVPiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:38:00 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:37825 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbaJVPhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:37:39 -0400
Date: Wed, 22 Oct 2014 16:37:24 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH -next 0/9] pty fixes
Message-ID: <20141022163724.065ab3b1@alan.etchedpixels.co.uk>
In-Reply-To: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
References: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 15:33:21 -0400
Peter Hurley <peter@hurleysoftware.com> wrote:

> Hi Greg,
> 
> This series addresses some pecularities of the pty driver, especially
> set_termios() handling, which is moved into the pty driver proper, and
> packet mode/ctrl_lock behavior.
> 
> Regards,
> 
> Peter Hurley (9):
>   tty: WARN for attempted set_termios() of pty master
>   tty: Move pty-specific set_termios() handling to pty driver
>   pty: Use spin_lock_irq() for pty_set_termios()
>   tty: Use spin_lock_irq() for ctrl_lock when interrupts enabled
>   pty: Don't claim slave's ctrl_lock for master's packet mode
>   pty: Fix packet mode setting race
>   pty: Hold ctrl_lock for packet mode updates
>   tty: Fix missed wakeup from packet mode status update
>   n_tty: Only process packet mode data in raw mode
> 
>  drivers/tty/n_tty.c     | 39 +++++++++++++++++++------------------
>  drivers/tty/pty.c       | 51 ++++++++++++++++++++++++++++++++++++-------------
>  drivers/tty/tty_ioctl.c | 34 ++++-----------------------------
>  3 files changed, 62 insertions(+), 62 deletions(-)
> 

Reviewed-by: Alan Cox <alan@linux.intel.com>

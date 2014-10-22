Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaJVPAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:00:23 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:37751 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaJVPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:00:21 -0400
Date: Wed, 22 Oct 2014 16:00:04 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH -next 00/10] Fixes to controlling tty handling
Message-ID: <20141022160004.11be0850@alan.etchedpixels.co.uk>
In-Reply-To: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
References: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 14:59:40 -0400
Peter Hurley <peter@hurleysoftware.com> wrote:

> Hi Greg,
> 
> This patch series:
> 1. removes stale code from the controlling tty handling functions
> 2. relocates the ctty functions to eliminate forward declarations
> 3. fixes several unsafe races when setting the controlling tty
> 4. eliminates holding tty_mutex as a necessary condition of
>    setting the controlling terminal
> 
> #4 is part of an overall effort to reduce the tty_mutex footprint.
> 
> Unfortunately, this series does not fix two other race conditions:
> 1. disassociate_ctty()/no_tty() does not teardown the tty<->process
> associations atomically wrt job control, so it is possible to
> observe spurious error conditions from job control (tty_check_change()
> and job_control()). I'm looking into inverting the lock order of
> tty->ctrl_lock and tsk->sighand->siglock() to see if holding ctrl_lock
> is a suitable solution for atomic teardown. Especially now that
> ctrl_lock is not used for flow control anymore :)
> 2. task_pgrp() and task_session() are used unsafely. These fixes
> will be clearer after #1 is fixed.


Reviewed-by: Alan Cox <alan@linux.intel.com>

I can't prove entirely to my satisfaction that the claim in #9 is true in
the presence of simultaenous hangups opens and setsid but the locking
appears to be correct for the cases I was trying to figure out anyway.

Makes my head hurt just reviewing bits of this so thanks for doing all
this work !

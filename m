Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab3APHdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:33:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3APHd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:33:29 -0500
Date: Tue, 15 Jan 2013 23:37:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-Id: <20130115233742.e8571f92.akpm@linux-foundation.org>
In-Reply-To: <1358272714-23375-1-git-send-email-jack@suse.cz>
References: <1358272714-23375-1-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 18:58:34 +0100 Jan Kara <jack@suse.cz> wrote:

> A CPU can be caught in console_unlock() for a long time (tens of seconds are
> reported by our customers) when other CPUs are using printk heavily and serial
> console makes printing slow.  This triggers softlockup warnings because
> interrupts are disabled for the whole time console_unlock() runs (e.g.
> vprintk() calls console_unlock() with interrupts disabled).

It should trigger the NMI watchdog in that case?

> We fix the issue by printing at most 1 KB of messages (unless we are in an
> early boot stage or oops is happening) in one console_unlock() call. The rest
> of the buffer will be printed either by further callers to printk() or by a
> queued work.

Complex.  Did you try just putting a touch_nmi_watchdog() in the loop?

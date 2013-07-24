Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab3GXAEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:04:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab3GXAEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:04:34 -0400
Date: Tue, 23 Jul 2013 17:04:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2 0/9] mostly lockless tty echo
Message-ID: <20130724000433.GA27651@kroah.com>
References: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
 <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 10:04:20AM -0400, Peter Hurley wrote:
> ** v2 changes **
> - Rebased on v2 of 'lockless tty flip buffers'
> 
> This 3rd of 4 patchsets implements a mostly-lockless tty echo output.
> 
> Because echoing is performed solely by the single-threaded ldisc
> receive_buf() method, most of the lockless requirements are already
> in-place. The main existing complications were;
> 1) Echoing could overrun itself. A fixed-size buffer is used to record
>    the operations necessary when outputting the echoes; the most recent
>    echo data is preserved.
> 2) An attempt to push unprocessed echoes is made by the n_tty_write method
>    (on a different thread) before attempting write output.
> 
> The overrun condition is solved by outputting the echoes in blocks and
> ensuring that at least that much space is available each time an echo
> operation is committed. At the conclusion of each flip buffer received,
> any remaining unprocessed echoes are output.
> 
> This block output method is particularly effective when there is no reader
> (the tty is output-only) and termios is misconfigured with echo enabled.
> 
> The concurrent access by the n_tty_write() method is already excluded
> by the existing output_lock mutex.

Applied, thanks.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3EPOFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:05:49 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:60382 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab3EPOFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:05:42 -0400
Date: Thu, 16 May 2013 10:05:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: channing <chao.bi@intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_buffer: avoid race due to tty_buffer_free_all()
 being misused
Message-ID: <20130516140518.GC2629@kroah.com>
References: <1368694762.2911.16.camel@bichao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368694762.2911.16.camel@bichao>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 04:59:22PM +0800, channing wrote:
> 
> In tty_buffer.c, function tty_buffer_free_all() is used to remove
> all buffers for a tty, although it's declared that it mustn't be called
> when the tty is in use, it cannot guarantee that. we can observe some
> device driver make use it by mistake, for example, while tty device is
> releasing, the tty data forwarding is not stopped, then it might hit
> the case that tty buffer is being used while tty_buffer_free_all()
> free this tty buffer, and finally lead to random error at any places,
> and it's not clear to debug.
> 
> Although device driver could do better, it's simpler and safer to
> strengthen protection in the view of tty buffer, by adding a tty->buf.lock
> in tty_buffer_free_all() to avoid it racing with ongoing tty buffer
> operations.
> 
> Signed-off-by: channing <chao.bi@intel.com>

Note, in the future, I need a "full" name for a signed-off-by: line and
>From line in the patch.

thanks,

greg k-h

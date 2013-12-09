Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab3LIIW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:22:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3LIIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:22:28 -0500
Date: Sun, 8 Dec 2013 17:12:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>, Karl Dahlke <eklhad@comcast.net>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 0/4] tty: Fix ^C echo
Message-ID: <20131209011220.GA7671@kroah.com>
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 04:12:01PM -0500, Peter Hurley wrote:
> Greg,
> 
> Sometimes when interrupting terminal output, the '^C' won't be echoed
> until more output is echoed. This is fairly repeatable by interrupting
> 'cat large-file'.
> 
> The common reason for this is because the tty write buffer is full,
> even though the write buffer _should_ have been flushed already.
> Because of a known deadlock, the pty driver does not perform a
> write buffer flush in its flush_buffer() method.
> 
> [Refer to the FIXME in pty_flush_buffer() from commit
> d945cb9cce20ac7143c2de8d88b187f62db99bdc,
> 'pty: Rework the pty layer to use the normal buffering logic']
> 
> Patch 1 fixes a stale comment.
> Patch 2 adds the necessary interfaces to avoid direct linkage
> between the N_TTY line discipline and the pty driver.
> Patch 3 avoids the deadlock while performing the write buffer flush.
> Patch 4 fixes a less common condition introduced by the echo batch
> processing added in 3.12.
> 
> Alan,
> 
> I cc'd you because of your recent involvement in other
> tty patches/bug fixes and because it's your FIXME comment.
> Feel free to ignore and/or let me know you would prefer not to
> be bothered.

Peter, this series doesn't fix the ^C echo problem that Karl recently
reported, so I'll hold off in applying it for now.

thanks,

greg k-h

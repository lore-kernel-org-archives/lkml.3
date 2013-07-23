Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335Ab3GWXxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:53:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab3GWXxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:53:30 -0400
Date: Tue, 23 Jul 2013 16:53:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2 6/9] n_tty: Process echoes in blocks
Message-ID: <20130723235329.GA14499@kroah.com>
References: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
 <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371305069-5366-7-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371305069-5366-7-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 10:04:26AM -0400, Peter Hurley wrote:
> Byte-by-byte echo output is painfully slow, requiring a lock/unlock
> cycle for every input byte.
> 
> Instead, perform the echo output in blocks of 256 characters, and
> at least once per flip buffer receive. Enough space is reserved in
> the echo buffer to guarantee a full block can be saved without
> overrunning the echo output. Overrun is prevented by discarding
> the oldest echoes until enough space exists in the echo buffer
> to receive at least a full block of new echoes.

I'm a bit worried about this, I wonder if anything is expecting the
echos to not come in "bursts" like this, but I really can't think of why
they would want that.

So let's apply it and see what breaks!  :)

thanks,

greg k-h

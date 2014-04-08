Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbaDHNNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:13:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43344 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaDHNNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:13:00 -0400
Date: Tue, 8 Apr 2014 15:12:27 +0200
From: Johan Hovold <johan@hovold.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Xiao Jin <jin.xiao@intel.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
Message-ID: <20140408131227.GD25779@localhost>
References: <53436770.9090008@intel.com>
 <20140408122229.67e2658e@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408122229.67e2658e@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +CC: Oliver ]

On Tue, Apr 08, 2014 at 12:22:29PM +0100, One Thousand Gnomes wrote:
> > (2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
> > close. If acm resume callback run after ASYNCB_INITIALIZED flag
> > cleared, there will have no chance for delayed write to start.
> > That lead to acm_wb.use can't be cleared. If user space open
> > acm tty again and try to setd, tty will be blocked in
> > tty_wait_until_sent for ever.
> 
> If there is data pending when the close occurs the close path should
> block until either the close timeout occurs or the buffer is written.
> This sounds more like the implementation of the ACM chars_in_buffer
> method is wrong and not counting the deferred bytes as unsent ?

The ACM chars_in_buffer does count the deferred bytes so I guess this
can only happen if close happens fast enough that resume is never called
before shutdown (e.g. closing_wait = ASYNC_CLOSING_WAIT_NONE and
drain_delay = 0).

Johan

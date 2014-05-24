Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaEXOnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 10:43:12 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37020 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaEXOnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 10:43:11 -0400
Date: Sat, 24 May 2014 16:42:42 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Xiao Jin <jin.xiao@intel.com>, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com, Johan Hovold <jhovold@gmail.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH] USB: cdc-acm: fix broken runtime suspend
Message-ID: <20140524144242.GC10266@localhost>
References: <20140411093715.GA17522@localhost>
 <1397505492-10018-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397505492-10018-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:58:12PM +0200, Johan Hovold wrote:
> The current ACM runtime-suspend implementation is broken in several
> ways:
> 
> Firstly, it buffers only the first write request being made while
> suspended -- any further writes are silently dropped.
> 
> Secondly, writes being dropped also leak write urbs, which are never
> reclaimed (until the device is unbound).
> 
> Thirdly, even the single buffered write is not cleared at shutdown
> (which may happen before the device is resumed), something which can
> lead to another urb leak as well as a PM usage-counter leak.
> 
> Fix this by implementing a delayed-write queue using urb anchors and
> making sure to discard the queue properly at shutdown.
> 
> Reported-by: Xiao Jin <jin.xiao@intel.com>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Greg, 

I understand yoǘ're on your way home from Japan and are getting ready to
work through the 3.16 patch queue.

Could you please discard this one for now? I've found a couple of more
PM related problems and I'll submit a slight update of this one as part
of a larger series of fixes instead.

Thanks,
Johan

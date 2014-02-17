Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaBQPiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:38:06 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34557 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBQPiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:38:03 -0500
Date: Mon, 17 Feb 2014 15:37:48 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] serial/uart: Add tunable RX interrupt trigger I/F of
 FIFO buffers
Message-ID: <20140217153748.513230fb@alan.etchedpixels.co.uk>
In-Reply-To: <52FDD470.7000607@hitachi.com>
References: <20140206021655.8613.52786.stgit@yunodevel>
	<20140213181007.GA24155@kroah.com>
	<52FDD470.7000607@hitachi.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> #define TIOCSFIFORTRIG    _IOW('T', 0x41, unsigned char)
> 
> > Also, why pass a pointer to a variable, and not just the value itself?
> 
> Ah, it's no big reason.
> It will pass just the value itself in V2.

We don't need ioctls here - we have a sysfs interface we can expand to do
this. We also need proper locking. This isn't a trivial change but its
perfectly doable given a real world use case.

> According to a manual of setserial command, we could set RX interrupt
> trigger only for the Hayes ESP serial driver. However, current kernel
> does not support Hayes ESP serial[1]. I couldn't find this feature for
> current 8250/16X50 drivers.

It is long gone and was a set of ugly device specific hacks.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3ALRjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:39:00 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38339 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753693Ab3ALRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:38:59 -0500
Date: Sat, 12 Jan 2013 12:38:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andreas Mohr <andi@lisas.de>
cc: Woody Suwalski <terraluna977@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
In-Reply-To: <20130112131602.GA32186@rhlx01.hs-esslingen.de>
Message-ID: <Pine.LNX.4.44L0.1301121237570.32458-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2013, Andreas Mohr wrote:

> There's of course the EHCI vs. UHCI(/OHCI) duality
> (EHCI host controller responsible for high speed transfers,
> the other for 1.1 full speed, both serving the same port connectors).
> So if the coordination between the two is a problem,
> you might end up with merely full speed on a 2.0 port.
> 
> And with drivers builtin vs. module, the init sequence/timing
> might possibly be affected - right?
> Perhaps this got worsened by semi-recent driver init kernel changes?
> (AFAIR the kernel was changed to init more things in parallel,
> for faster bootup). So maybe that affected EHCI vs. UHCI coordination timing.

Another important change is that the EHCI driver is now split into two 
modules.  That can slow down loading and affect the timing.

Alan Stern


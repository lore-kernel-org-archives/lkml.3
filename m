Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3FLDEC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 23:04:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3FLDEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:04:00 -0400
Date: Tue, 11 Jun 2013 20:04:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB 3.0 failure and possible regression in kernel 3.8.0
Message-ID: <20130612030435.GC9398@kroah.com>
References: <749753.81252.qm@web100019.mail.kks.yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <749753.81252.qm@web100019.mail.kks.yahoo.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:25:32AM +0900, Norman Diamond wrote:
> Kernels somewhere around 2.6.35 could handle USB 3.0 at random sometimes,
> but kernel 3.8.0 fails consistently.  I know I should try to bisect this,
> but I don't have time and the randomness of the older kernel doesn't help.
> 
> lspci:
> 0d:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0 Host Controller
>  [1033:0194] (rev 04)
>          Kernel driver in use: xhci_hcd
> 
> lsusb:
> Bus 007 Device 002: ID 152d:0539 JMicron Technology Corp. / JMicron USA Technology Corp.
> 
> dmesg:
> [  458.857081] usb 6-1: new high-speed USB device number 2 using xhci_hcd
> [  463.857085] xhci_hcd 0000:0d:00.0: Timeout while waiting for address device command
> [  464.728073] xhci_hcd 0000:0d:00.0: Stopped the command ring failed, maybe the host is dead
> [  464.728073] xhci_hcd 0000:0d:00.0: Host not halted after 16000 microseconds.
> [  464.728073] xhci_hcd 0000:0d:00.0: Abort command ring failed
> [  479.976010] [sched_delayed] sched: RT throttling activated
> [  479.987230] xhci_hcd 0000:0d:00.0: HC died; cleaning up

Can you try a newer kernel (hint, 3.8.0 is old and obsolete)?  3.10-rc5
would be great, but I'll settle for 3.9.5 if you can try that.

thanks,

greg k-h

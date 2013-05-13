Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3EMOPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:15:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56385 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751846Ab3EMOPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:15:33 -0400
Date: Mon, 13 May 2013 10:15:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: linux fddl <fddllinux@gmail.com>
cc: linux-usb@vger.kernel.org, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: usb: why we need a msleep(5) in ehci_bus_suspend/resume
In-Reply-To: <CAGALBbBJuVRcG9zcqcTSNHJ4FsyE9DuHhvzRZQdEePEq=GXMFg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1305131014060.1389-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, linux fddl wrote:

> Hi,
> 
>   From the ehci-hub.c, I find that ehci_bus_suspend/resume have some
> code like this:
> 
> if (time_before(jiffies, ehci->netx_statechange))
>     msleep(5);
> ...
> ehci->next_statechange = jiffies + msec_to_jiffies(10);
> 
> and
> 
> if (time_before(jiffies, ehci->netx_statechange))
>     msleep(5);
> ...
> ehci->next_statechange = jiffies + msec_to_jiffies(5);
> 
> but I don't know why such a short sleep is needed, and why one is
> [ehci->next_statechange = jiffies + msec_to_jiffies(10)] and the other is
> [ehci->next_statechange = jiffies + msec_to_jiffies(5)],
> I googled for a long time, but it seems that there is no explanation.
> 
>   Anyone knows why and can give any explanation?

At this point I don't think anybody knows.  The person who originally
wrote that code died a few years ago.

Alan Stern


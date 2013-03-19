Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab3CSPsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:48:15 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33725 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756902Ab3CSPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:48:08 -0400
Date: Tue, 19 Mar 2013 11:48:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
cc: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <Julia.Lawall@lip6.fr>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, <john453@faraday-tech.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
In-Reply-To: <CADB-GoLzX-G5j92oEsLeUq6PRpKwb15U6LL_jw4zh6Nhh+ZHLg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303191142330.15684-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Yuan-Hsin Chen wrote:

> > What about the port_status registers?  They're not between command and
> > async_next.  If they aren't consistent with EHCI, it makes things a lot
> > more complicated.
> 
> fusbh200 has only one port_status register with different offset,
> 0x30, and the position of some bits are different from EHCI.

That's pretty nasty.  Integrating that with the standard EHCI driver 
would be considerably more difficult.

Why was the FUSBH200 designed in this strange way?  Why doesn't it use 
the standard EHCI register layout?  Were the engineers at Faraday 
deliberately trying to make life harder for driver writers?

> Also, usbmode_ex, hostpc, and txfill_tuning other than configured_flag
> are non-existent in fusbh200. They are used in both ehci-hcd.c and
> ehci-hub.c for several times.

They are used only if the hardware supports them, that is, only if the
ehci->has_hostpc flag is set.

Alan Stern


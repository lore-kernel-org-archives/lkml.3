Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3CTO0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:26:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58396 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750839Ab3CTO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:26:10 -0400
Date: Wed, 20 Mar 2013 10:26:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
cc: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <Julia.Lawall@lip6.fr>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>, <john453@faraday-tech.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
In-Reply-To: <CADB-GoLncGoXmJsxXPUZocz1fJe9uUBX+mtgBVkuUR1SqbOBEQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303201024190.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013, Yuan-Hsin Chen wrote:

> Hi,
> 
> On Tue, Mar 19, 2013 at 11:48 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Tue, 19 Mar 2013, Yuan-Hsin Chen wrote:
> >
> >> > What about the port_status registers?  They're not between command and
> >> > async_next.  If they aren't consistent with EHCI, it makes things a lot
> >> > more complicated.
> >>
> >> fusbh200 has only one port_status register with different offset,
> >> 0x30, and the position of some bits are different from EHCI.
> 
> How about adding kernel configuration to adjust offset for FUSBH200 in
> ehci_def.h? So port_status would be in offset 0x20 from ehci_regs.
> 
> For example,
> 
>         /* ASYNCLISTADDR: offset 0x18 */
>         u32             async_next;     /* address of next async queue head */
> 
> #ifndef CONFIG_USB_EHCI_HCD_FUSBH200
>         u32             reserved1[2];
> 
>         /* TXFILLTUNING: offset 0x24 */
>         u32             txfill_tuning;  /* TX FIFO Tuning register */
> #define TXFIFO_DEFAULT  (8<<16)         /* FIFO burst threshold 8 */
> 
>         u32             reserved2[6];
> 
>         /* CONFIGFLAG: offset 0x40 */
>         u32             configured_flag;
> #define FLAG_CF         (1<<0)          /* true: we'll support "high speed" */
> 
> #else
>         u32             reserved1;
> #endif
>         /* PORTSC: offset 0x44 */
>         u32             port_status[0]; /* up to N_PORTS */

This is acceptable _only_ if it is not possible to use an FUSBH200 
controller in the same computer as a normal EHCI controller.

> Furthermore, there are PORT_POWER, PORT_OWNER, PORT_LED_XXX,
> PORT_TEST, PORT_WKCONN_E, PORT_WKDISC_E, PORT_WKOC_E absent in
> port_status of FUSBH200. Also PORT_OC and PORT_OCC are in another
> register. Is it ok to use quirk flag also?

Yes, those can be handled by a quirk flag.  Does the FUSBH200 have a 
built-in Transaction Translator?

Alan Stern


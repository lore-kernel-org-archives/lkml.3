Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3GJTIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:08:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41028 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754374Ab3GJTIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:08:44 -0400
Date: Wed, 10 Jul 2013 15:08:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/6] USB: Support wakeup IRQ for suspended controllers
In-Reply-To: <1373473393-27552-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1307101504220.1215-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Roger Quadros wrote:

> Some platforms e.g. ehci-omap can generate an interrupt
> (i.e. remote wakeup) even when the controller is suspended i.e.
> HW_ACCESSIBLE is cleared.
> 
> Introduce a flag "has_wakeup_irq" in struct usb_hcd to indicate
> such cases.
> 
> We tackle this case by disabling the IRQ, scheduling a
> hub resume and enabling back the IRQ after the controller has
> resumed. This ensures that the IRQ handler runs only after the
> controller is accessible.

Oh yes, one more thing...

> @@ -132,6 +134,7 @@ struct usb_hcd {
>  	unsigned		wireless:1;	/* Wireless USB HCD */
>  	unsigned		authorized_default:1;
>  	unsigned		has_tt:1;	/* Integrated TT in root hub */
> +	unsigned		has_wakeup_irq:1; /* Can IRQ when suspended */

Please add a highly visible comment here, warning that has_wakeup_irq
should never be set on systems with shared IRQs.  Having both would ...
well, it would indicate a really bad system design.

Alan Stern


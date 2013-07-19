Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234Ab3GSPON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:14:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50821 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752131Ab3GSPOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:14:11 -0400
Date: Fri, 19 Jul 2013 11:14:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Peter Hurley <peter@hurleysoftware.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>, <jkosina@suse.cz>,
        <benjamin.tissoires@gmail.com>, <adlr@chromium.org>,
        <joseph.salisbury@canonical.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "Revert "HID: Fix logitech-dj: missing Unifying
 device issue""
In-Reply-To: <20130718220936.GA8025@xanatos>
Message-ID: <Pine.LNX.4.44L0.1307191008200.1055-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013, Sarah Sharp wrote:

> Question: does this USB device need a control transfer to reset its
> endpoints when the endpoints are not actually halted?  If so, yes, that
> is a known xHCI driver bug that needs to be fixed.  The xHCI host will
> not accept a Reset Endpoint command when the endpoints are not actually
> halted, but the USB core will send the control transfer to reset the
> endpoint.  That means the device and host toggles will be out of sync,
> and all messages will start to fail with -EPIPE.

Why -EPIPE?  Isn't that code reserved to indicate a STALL?

In fact, there's no way to detect a toggle mismatch problem with a 
USB-2 device.  Packets with the wrong toggle value are simply ignored 
(or acknowledged and ignored).  The problem ends up appearing as an 
indefinite delay (for an IN transfer) or as data lost (for an OUT 
transfer).

I don't know what happens with USB-3 devices when the sequence numbers 
get out of alignment.

Alan Stern


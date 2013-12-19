Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3LSPvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:51:55 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55840 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755055Ab3LSPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:51:50 -0500
Date: Thu, 19 Dec 2013 10:51:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rashika Kheria <rashika.kheria@gmail.com>
cc: linux-kernel@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <josh@joshtriplett.org>
Subject: Re: [PATCH 4/7] drivers: usb: Include appropriate header file in
 pci-quirks.c
In-Reply-To: <e0ff2366ddbd62f75e8597008b1f3f9001224ad6.1387439261.git.rashika.kheria@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1312191047440.984-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Rashika Kheria wrote:

> Include header file include/linux/usb/hcd.h in host/pci-quirks.c because
> function usb_hcd_amd_remote_wakeup_quirk() has its prototype declaration
> in include/linux/usb/hcd.h.
> 
> This eliminates the following warning in host/pci-quirks.c:
> drivers/usb/host/pci-quirks.c:253:5: warning: no previous prototype for ‘usb_hcd_amd_remote_wakeup_quirk’ [-Wmissing-prototypes]

Since when does the compiler complain about functions with no 
prototype?

In any case, I think it would make more sense to move the prototype 
declaration into drivers/usb/host/pci-quirks.h, and have 
drivers/usb/core/hcd-pci.c include that file.  After all, it's 
perfectly reasonable for hcd-pci to want to know about the quirks of 
various PCI-based controllers, but it's not reasonable for pci-quirks.c 
to need to know about the details of HCDs.

Alan Stern


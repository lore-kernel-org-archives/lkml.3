Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab3HZQpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:45:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59208 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757164Ab3HZQo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:44:59 -0400
Date: Mon, 26 Aug 2013 12:44:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <tomk@rgmadvisors.com>
Subject: Re: [PATCH] USB: Fix compilation error when CONFIG_PM disabled
In-Reply-To: <1377534914-7145-1-git-send-email-sbohrer@rgmadvisors.com>
Message-ID: <Pine.LNX.4.44L0.1308261244170.1445-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013, Shawn Bohrer wrote:

> Commit 9a11899c5e699a8d "USB: OHCI: add missing PCI PM callbacks to
> ohci-pci.c" Introduced the following compilation errors when power
> management is disabled:
> 
> drivers/usb/host/ohci-pci.c: In function 'ohci_pci_init':
> drivers/usb/host/ohci-pci.c:309:35: error: 'ohci_suspend' undeclared (first use in this function)
> drivers/usb/host/ohci-pci.c:309:35: note: each undeclared identifier is reported only once for each function it appears in
> drivers/usb/host/ohci-pci.c:310:34: error: 'ohci_resume' undeclared (first use in this function)
> 
> ohci_suspend and ohci_resume are only defined when CONFIG_PM is defined
> so only use them under CONFIG_PM.

Heh -- beat you to it.

	http://marc.info/?l=linux-usb&m=137752885015904&w=2

Alan Stern


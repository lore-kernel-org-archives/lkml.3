Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3FDSLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:11:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36466 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751143Ab3FDSLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:11:33 -0400
Date: Tue, 4 Jun 2013 14:11:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: host: make USB_ARCH_HAS_?HCI obsolete
In-Reply-To: <201306041942.22904.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1306041410530.1093-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Arnd Bergmann wrote:

> The three options USB_ARCH_HAS_{EHCI,OHCI,XHCI} are all well beyond
> their recommended shelf life. They have caused numerous build failures
> over the years because they are never completely correct, and with
> the move to splitting out the platform specific back-ends out of the
> driver, there is no real need for them any more. Also, the use of making
> USB_ARCH_HAS_HCD depend on it is questionable since one can always enable
> dummy_hc these days.
> 
> This patch enables them unconditionally for all platforms and
> architectures, which means it is now possible to build host controller
> drivers for machines that are known not to come with this hardware,
> but that is just how we treat most other drivers.
> 
> In order to minimise the impact on existing architecture code and
> defconfig files, all the Kconfig are left present for now. All platforms
> that currently do 'select USB_ARCH_HAS_*' should subsequently be changed
> not to select that. All drivers depending on USB_ARCH_HAS_HCD should
> be changed to depend on USB_SUPPORT instead.

Acked-by: Alan Stern <stern@rowland.harvard.edu>


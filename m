Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaE0PIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:08:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42589 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751737AbaE0PIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:08:53 -0400
Date: Tue, 27 May 2014 11:08:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lugovskoy@dev.rtsoft.ru>
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
In-Reply-To: <1401166602-26379-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.44L0.1405271055240.1372-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Nikita Yushchenko wrote:

> This access causes hang on Freescale P2020DS board (that has OHCI
> provided by ULI 1533 chip).

Which access, the read or the write?

> Since preserving OHCI_FMINTERVAL was originally done only for NVIDIA
> hardware and only later (in c6187597) was turned unconditional, and

Correction: Preserving OHCI_FMINTERVAL was originally done for all 
controllers that needed to be reset.  It just so happened that NVIDIA 
was the only one that got reset.  In c6187597 the reset became 
unconditional, so fminterval was preserved for all hardware.

> c6187597 commit message again mentions only NVIDIA, I think it should be
> safe to disable preserving OHCI_FMINTERVAL if device vendor is ULI.
> 
> Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

It looks like you haven't read ohci_shutdown() and ohci_run() in 
drivers/usb/host/ohci-hcd.c.  They both access the fminterval register, 
and this patch doesn't change them.

So I don't see why this patch should make any difference to the 
system's operation.

Alan Stern


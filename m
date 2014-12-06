Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaLFOqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 09:46:34 -0500
Received: from netrider.rowland.org ([192.131.102.5]:59386 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751466AbaLFOqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 09:46:31 -0500
Date: Sat, 6 Dec 2014 09:46:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arseny Solokha <asolokha@kb.kras.ru>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] OHCI: add a quirk for ULi M5237 blocking on reset
In-Reply-To: <1417834446-21257-1-git-send-email-asolokha@kb.kras.ru>
Message-ID: <Pine.LNX.4.44L0.1412060945160.25285-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2014, Arseny Solokha wrote:

> From: Arseny Solokha <asolokha@kb.kras.ru>
> 
> Commit 8dccddbc2368 ("OHCI: final fix for NVIDIA problems (I hope)")
> introduced into 3.1.9 broke boot on e.g. Freescale P2020DS development
> board. The code path that was previously specific to NVIDIA controllers
> had then become taken for all chips.
> 
> However, the M5237 installed on the board wedges solid when accessing
> its base+OHCI_FMINTERVAL register, making it impossible to boot any
> kernel newer than 3.1.8 on this particular and apparently other similar
> machines.
> 
> Don't readl() and writel() base+OHCI_FMINTERVAL on PCI ID 10b9:5237.
> 
> The patch is suitable for the -next tree as well as all maintained
> kernels up to 3.2 inclusive.
> 
> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
> ---
> Changes in v2:
> - review comments applied

Much better this time.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern


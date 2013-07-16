Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab3GPSrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:47:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58148 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754956Ab3GPSrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:47:04 -0400
Date: Tue, 16 Jul 2013 14:47:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: boris brezillon <b.brezillon@overkiz.com>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] USB: ohci-at91: add usb_clk for transition to
 common clk framework
In-Reply-To: <51E57DFC.5030302@overkiz.com>
Message-ID: <Pine.LNX.4.44L0.1307161441350.1032-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, boris brezillon wrote:

> >> +	uclk = clk_get(&pdev->dev, "usb_clk");
> >> +	if (IS_ERR(uclk)) {
> >> +		uclk = NULL;
> >> +		dev_warn(&pdev->dev, "failed to get usb_clk\n");
> >> +	}
> > Is this really what you want for backward compatibility?
> Here are some proposition to remove the warning message:
> 
> 1) replace it with a dev_info and change the message:
>      dev_info(&pdev->dev, "failed to get usb_clk (most likely using old 
> at91 clk implementation)\n");
> 2) drop the log and silently ignore the missing clk (I'm not a big fan 
> of this solution
>      as it may lead to some errors if we're using new clk implem and the 
> clock is really missing)
> 3) rework the current clk_set_rate function to accept clk_set_rate on 
> usb clk and add clk_lookup entries
>      for the usb clk (I'm not a big fan of this solution neither as this 
> modifications will only be used for a short time
>      until the transition to common clk framework is completed).

Another possibility is to combine this change with the clock 
implementation update, and do them in a single patch.  Then backward 
compatibility would not be an issue.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3HAP4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:56:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57762 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756368Ab3HAP4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:56:10 -0400
Date: Thu, 1 Aug 2013 11:56:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: boris brezillon <b.brezillon@overkiz.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: ohci-at91: add usb_clk for transition to common
 clk framework
In-Reply-To: <51FA7B6A.80106@overkiz.com>
Message-ID: <Pine.LNX.4.44L0.1308011153180.1534-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Aug 2013, boris brezillon wrote:

> > What happens if uclk isn't found but it is needed?
> It will not fail but I guess the usb host won't work as the clock won't 
> be correctly
> configured.
> 
> I agree with you: this is not a good solution.
> 
> Another option is to keep the previous version of this patch and put 
> uclk handling
> in "#ifdef CONFIG_COMMON_CLK #endif" sections.
> 
> Would this be acceptable ?

Yes.  However, a more elegant approach is to protect the relevant 
statements with: if (defined(CONFIG_COMMON_CLK)).  This preprocessor 
evaluates this to a 0 or 1, so the compiler will not generate output 
for the protected source code if the symbol isn't defined.

Alan Stern


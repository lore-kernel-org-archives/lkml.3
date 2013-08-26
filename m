Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab3HZQo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:44:58 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40270 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623Ab3HZQo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:44:56 -0400
X-Sasl-enc: rFmoAKIQWdcd6uxN6P9Iy6u76haPUL12N1SWegFFGCcq 1377535493
Date: Mon, 26 Aug 2013 09:47:09 -0700
From: Greg KH <greg@kroah.com>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tomk@rgmadvisors.com
Subject: Re: [PATCH] USB: Fix compilation error when CONFIG_PM disabled
Message-ID: <20130826164709.GA1858@kroah.com>
References: <1377534914-7145-1-git-send-email-sbohrer@rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377534914-7145-1-git-send-email-sbohrer@rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 11:35:14AM -0500, Shawn Bohrer wrote:
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
> 
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>

Alan sent this patch an hour or so ago, sorry.

I'll add your Signed-off-by: to his patch though, when I queue it up for
Linus in a few hours (I'm in an airport at the moment...)

thanks,

greg k-h

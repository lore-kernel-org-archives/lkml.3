Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3HZPgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:36:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3HZPgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:36:24 -0400
Date: Mon, 26 Aug 2013 08:38:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Guenter Roeck <linux@roeck-us.net>, Meelis Roos <mroos@linux.ee>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steve Cotton <steve@s.cotton.clara.co.uk>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: OHCI: fix build error related to ohci_suspend/resume
Message-ID: <20130826153840.GA29862@kroah.com>
References: <20130826042653.GA2778@kroah.com>
 <Pine.LNX.4.44L0.1308261051340.1445-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1308261051340.1445-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 10:53:53AM -0400, Alan Stern wrote:
> Commit 9a11899c5e69 (USB: OHCI: add missing PCI PM callbacks to
> ohci-pci.c) added missing ohci_suspend and ohci_resume callback
> pointers, but forgot that these callbacks are declared and defined
> only when CONFIG_PM is enabled.
> 
> This patch adds a preprocessor conditional to avoid build errors when
> PM is disabled.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---

Guenter and Meelis, does the patch below fix the problem for you?

thanks,

greg k-h

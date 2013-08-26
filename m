Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3HZLmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:42:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab3HZLmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:42:11 -0400
Date: Mon, 26 Aug 2013 04:44:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.11-rc7: compile failure in ohci
Message-ID: <20130826114427.GA27507@kroah.com>
References: <alpine.SOC.1.00.1308261232390.25531@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.SOC.1.00.1308261232390.25531@math.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 12:46:03PM +0300, Meelis Roos wrote:
> Tried 3.11-rc7 and got this compile failure on a couple of hosts where 
> -rc6 worked. config is below.
> 
> This commit seems to break it:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=9a11899c5e699a8d2551692dfcd4372e39dcbdf6
> 
>   CC [M]  drivers/usb/host/ohci-pci.o
> drivers/usb/host/ohci-pci.c: In function ‘ohci_pci_init’:
> drivers/usb/host/ohci-pci.c:309:35: error: ‘ohci_suspend’ undeclared (first use in this function)
> drivers/usb/host/ohci-pci.c:309:35: note: each undeclared identifier is reported only once for each function it appears in
> drivers/usb/host/ohci-pci.c:310:34: error: ‘ohci_resume’ undeclared (first use in this function)
> make[3]: *** [drivers/usb/host/ohci-pci.o] Error 1

Sorry about that, known issue, if you enable CONFIG_PM_RUNTIME, it
should go away for now.

greg k-h

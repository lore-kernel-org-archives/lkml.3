Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaLORBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:01:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaLORBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:01:01 -0500
Date: Mon, 15 Dec 2014 09:01:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andreas Werner <andreas.werner@men.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mcb: mcb-pci: Only remap the 1st 0x200 bytes of BAR 0
Message-ID: <20141215170101.GB2155@kroah.com>
References: <1414512692-1433-1-git-send-email-johannes.thumshirn@men.de>
 <20141215132335.GA3439@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215132335.GA3439@jtlinux>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 02:23:37PM +0100, Johannes Thumshirn wrote:
> On Tue, Oct 28, 2014 at 05:11:32PM +0100, Johannes Thumshirn wrote:
> > Currently it is not possible to have a kernel with built-in MCB attached
> > devices. This results out of the fact that mcb-pci requests PCI BAR 0, then
> > parses the chameleon table and calls the driver's probe function before
> > releasing BAR 0 again. When building the kernel with modules this is not a
> > problem (and therefore it wasn't detected by my tests yet).
> > 
> > A solution is to only remap the 1st 0x200 bytes of a Chameleon PCI device.
> > 0x200 bytes is the maximum size of a Chameleon v2 Table.
> > 
> > Also this patch stops disabling the PCI device on successful registration of MCB
> > devices.
> > 
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> > Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Hi Greg,
> 
> Is there any specific reason why you didn't pick this one up for 3.19? Or did it
> just got lost in your queue?
> 

Hm, I didn't realize I was supposed to pick it up, sorry, I'm not listed
as the "mcb" maintainer, you are :)

Please resend and I'll pick it up after 3.19-rc1 is out.

thanks,

greg k-h

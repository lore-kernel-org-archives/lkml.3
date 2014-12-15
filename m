Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaLONaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:30:52 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.114]:52823 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbaLONav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:30:51 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2014 08:30:50 EST
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-14.tower-194.messagelabs.com!1418649821!19282548!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 15 Dec 2014 14:23:42 +0100
Date: Mon, 15 Dec 2014 14:23:37 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: Re: [PATCH] mcb: mcb-pci: Only remap the 1st 0x200 bytes of BAR 0
Message-ID: <20141215132335.GA3439@jtlinux>
References: <1414512692-1433-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1414512692-1433-1-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 05:11:32PM +0100, Johannes Thumshirn wrote:
> Currently it is not possible to have a kernel with built-in MCB attached
> devices. This results out of the fact that mcb-pci requests PCI BAR 0, then
> parses the chameleon table and calls the driver's probe function before
> releasing BAR 0 again. When building the kernel with modules this is not a
> problem (and therefore it wasn't detected by my tests yet).
> 
> A solution is to only remap the 1st 0x200 bytes of a Chameleon PCI device.
> 0x200 bytes is the maximum size of a Chameleon v2 Table.
> 
> Also this patch stops disabling the PCI device on successful registration of MCB
> devices.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> Suggested-by: Bjorn Helgaas <bhelgaas@google.com>

Hi Greg,

Is there any specific reason why you didn't pick this one up for 3.19? Or did it
just got lost in your queue?

Thanks,
	Johannes


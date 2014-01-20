Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaATLj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:39:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65306 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaATLjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:39:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Srikanth Thokala <sthokal@xilinx.com>
Subject: Re: [PATCH] dma: Add Xilinx AXI Video Direct Memory Access Engine driver support
Date: Mon, 20 Jan 2014 12:39:47 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1389894803-4147-1-git-send-email-sthokal@xilinx.com> <201401171713.08550.arnd@arndb.de> <CA+mB=1L0ZSC8f6eMEuO7MEk6nG5SDahE7AH2F_uUr1TgTCD=cw@mail.gmail.com>
In-Reply-To: <CA+mB=1L0ZSC8f6eMEuO7MEk6nG5SDahE7AH2F_uUr1TgTCD=cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401201239.47665.arnd@arndb.de>
X-Provags-ID: V02:K0:KiZl40Jo4O+/mH91QP6UbLzZWtxkWGfqQNbz4kMjkVG
 x4YleAnApOoQCLAXCX9SL87GTDnVneh8oo0fFMyhIYpa/WNHtD
 H61Hl5HmAlm1q0sb6PLGPBY5rxMMORjqUHotTVehs0Tqlad76P
 qi6hb8UzaMbhviTt+xtlix6vQwL/pUnJUc/Buy0nx61ObHpmFw
 mAZcuZCkuv57mZmPas3vAbq/ODLnQk3nz7ixPHIGh/Emo9F8fV
 g3zpt0hYmG6ijzpOr2CBF5JGIDueiosfKzGdDTR2h8uTXeDILQ
 TJ77kyDrj+TVYX+/ZTe9udHb7ayY06aMdfgqMiiIoqJlnoFOMk
 jyVBf5grqFpnNeQUyzDk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 January 2014, Srikanth Thokala wrote:
> On Fri, Jan 17, 2014 at 9:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 16 January 2014, Srikanth Thokala wrote:
> > I also assume that some of the properties should just go away:
> >
> > * xlnx,device-id should be the argument in the handle from the slave device
> 
> We can have multiple instances of this VDMA IP configured in the FPGA and we
> need a unique identifier for each VDMA device that is present in the FPGA.
> This device-id dt parameter forms the filter mask for the slave devices. As an
> example, this can be used to get a channel of specific VDMA device (assuming
> multiple instances) using the API dma_request_channel().  Please note this
> is an example of a slave device that doesnt have dt node.

That is not a valid scenario: You should not try to support legacy
slave devices (without DT) connected to a dma-engine that is initialized
using DT. If you still in the progress of converting drivers to DT, you
can use auxdata to attach additional information that can be used for
those slave devices, but the code should be kept out of the mainline
kernel, and I don't want to see it manifest in the bindings.

> > * data width should be a property of the slave driver that is configured
> >   through dma_slave_config(), unless you can have dma engines that only
> >   support certain a width.
> 
> Yes, this VDMA engine soft IP support only certain widths, which is
> configurable during IP synthesis.

But what is this property used for in that case? Surely you can't
connect a slave device to a dmaengine if the bus width doesn't match.
You probably have a point here, but I don't understand it yet.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3GLHjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:39:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:4798 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab3GLHjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:39:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,651,1367996400"; 
   d="scan'208";a="330289927"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] [RFC] usb: gadget: USB_GADGET should depend on HAS_DMA
In-Reply-To: <Pine.LNX.4.44L0.1307111145160.1276-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1307111145160.1276-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 12 Jul 2013 10:39:18 +0300
Message-ID: <8761wg2pnd.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Thu, 11 Jul 2013, Geert Uytterhoeven wrote:
>
>> If NO_DMA=y:
>> 
>> drivers/built-in.o: In function `dma_set_coherent_mask':
>> include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
>> include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
>> drivers/built-in.o: In function `usb_gadget_unmap_request':
>> drivers/usb/gadget/udc-core.c:91: undefined reference to `dma_unmap_sg'
>> drivers/usb/gadget/udc-core.c:96: undefined reference to `dma_unmap_single'
>> drivers/built-in.o: In function `usb_gadget_map_request':
>> drivers/usb/gadget/udc-core.c:62: undefined reference to `dma_map_sg'
>> drivers/usb/gadget/udc-core.c:71: undefined reference to `dma_map_single'
>> drivers/usb/gadget/udc-core.c:74: undefined reference to `dma_mapping_error'
>> 
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>> This one is very debatable: probably the parts using the DMA API should
>> be factored out, instead of disabling the whole USB gadget subsystem.
>
> Indeed.  How does this look instead?

This one is much better. FWIW,

Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>

Regards,
--
Alex

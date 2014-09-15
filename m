Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaIOR24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:28:56 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:41192
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbaIOR2z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:28:55 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] staging: comedi: adl_pci9118: redo DMA buffer
 allocation
Thread-Topic: [PATCH 0/3] staging: comedi: adl_pci9118: redo DMA buffer
 allocation
Thread-Index: AQHPzmig8+EuAL3YEkW6/xzsYQv5N5wCaWeQ
Date: Mon, 15 Sep 2014 17:28:52 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FA1985@P3PWEX4MB008.ex4.secureserver.net>
References: <1410512684-17403-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1410512684-17403-1-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 12, 2014 2:05 AM, Ian Abbott wrote:
> "adl_pci9118" allocates more pages of DMA buffer than it uses, may
> allocate half a double-buffer it does not use because it's the "wrong"
> half that it managed to allocate (unlikely), and relies on virt_to_bus()
> to treat generic kernel memory from get_free_pages() as coherent DMA
> memory.  Correct the issues, using dma_alloc_coherent() to allocate the
> DMA buffers.
>
> 1) staging: comedi: adl_pci9118: don't allocate 2nd DMA buffer on failure
> 2) staging: comedi: adl_pci9118: don't overallocate DMA buffer
> 3) staging: comedi: adl_pci9118: use dma_alloc_coherent()
>
>  drivers/staging/comedi/Kconfig               |  2 +-
>  drivers/staging/comedi/drivers/adl_pci9118.c | 40 ++++++++++++++--------------
>  2 files changed, 21 insertions(+), 21 deletions(-)

Thanks. Know I don't need to look into how to remove the
virt_to_bus()... ;-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>


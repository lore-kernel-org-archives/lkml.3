Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaGaRYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:24:47 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:57278
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762AbaGaRYp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:24:45 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: ii_pci20kc: request and ioremap memory
Thread-Topic: [PATCH] staging: comedi: ii_pci20kc: request and ioremap memory
Thread-Index: AQHPrM/Lh77rXd0Jgk+WiL9JzOaH3pu6aT5A
Date: Thu, 31 Jul 2014 17:24:44 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F2E536@P3PWEX4MB008.ex4.secureserver.net>
References: <1406818647-10107-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1406818647-10107-1-git-send-email-abbotti@mev.co.uk>
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

On Thursday, July 31, 2014 7:57 AM, Ian Abbott wrote:
> The "ii_pci20kc" module is a comedi driver for Intelligent Instruments
> PCI-20001C carrier board and modules.  Despite the name, this is
> actually an ISA board and uses 1K of ISA memory space (below 1M) for the
> main board plus up to three modules.  The address is set by hardware
> jumpers.
>
> When the board is attached to Comedi via the `COMEDI_DEVCONFIG` ioctl
> and the driver's legacy "attach" handler, the base address is passed in.
> The driver currently uses that address as-is, which is a bad idea.  It
> doesn't even reserve the memory region.
>
> Fix that by sanity checking the passed in address, reserving the memory
> region and ioremapping it.
>
> Replace the current "detach" handler `comedi_legacy_detach()` with a new
> handler `ii20k_detach()` which unmaps the memory and releases the
> region.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/drivers/ii_pci20kc.c | 32 ++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)

Thanks for fixing this!

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>


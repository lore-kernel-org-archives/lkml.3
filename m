Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3EIVef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:34:35 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.99]:29376 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076Ab3EIVee convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:34:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1368135271!6053562!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>
Date: Thu, 9 May 2013 16:33:01 -0500
Subject: RE: [PATCH 12/12] staging: COMEDI should depend on HAS_DMA
Thread-Topic: [PATCH 12/12] staging: COMEDI should depend on HAS_DMA
Thread-Index: Ac5M+P0ckMkT4QvPQMiYfdTASLXDYQAAyU+g
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021D46AC8173@AUSP01VMBX24.collaborationhost.net>
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
 <1368133494-22198-12-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1368133494-22198-12-git-send-email-geert@linux-m68k.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 09, 2013 2:05 PM, Geert Uytterhoeven wrote:
> If NO_DMA=y:
>
> ERROR: "dma_free_coherent" [drivers/staging/comedi/comedi.ko] undefined!
> ERROR: "dma_alloc_coherent" [drivers/staging/comedi/comedi.ko] undefined!
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: devel@driverdev.osuosl.org

Grr..

The error appears to be caused by the dma alloc/free in comedi_buf.c.
These only happen if the (s->async_dma_dir != DMA_NONE). The comedi
core defaults the async_dma_dir to DMA_NONE. The only comedi drivers
that set it are ni_660x, ni_mio_common, and ni_pcidio.

The mite driver also has a dma_alloc/free.

Ian, can you think of a better solution than just making comedi depend on HAS_DMA?

Thanks,
Hartley


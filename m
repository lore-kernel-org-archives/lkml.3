Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaIOSV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:21:26 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:37686
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbaIOSVZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:21:25 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/11] staging: comedi: move comedi_fc functionality
 into core
Thread-Topic: [PATCH 00/11] staging: comedi: move comedi_fc functionality
 into core
Thread-Index: AQHP0OMNmwbEu0+4Q0ufFBkx+BURX5wCgL7g
Date: Mon, 15 Sep 2014 18:21:23 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FA1BE3@P3PWEX4MB008.ex4.secureserver.net>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
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

On Monday, September 15, 2014 5:46 AM, Ian Abbott wrote:
> The "comedi_fc" module contains a few functions for use by several
> low-level comedi drivers.  Since they are used by quite a few drivers,
> it seems useful to migrate their functionality to the core "comedi"
> module, renaming them in the process, while keeping the original
> function names in "drivers/comedi_fc.h" available for now.  This set of
> patches accomplishes that.
>
> The next stages after this will be to migrate the remaining inline
> functions from "drivers/comedi_fc.h" (possibly making them externally
> exported functions, although they are rather short), and then to update
> the low-level drivers to call the functions with the new names,
> eliminating the need to include "comedi_fc.h".  Then
> "drivers/comedi_fc.h" can be removed as well.
>
> Note that PATCH 10 has a couple of checkpatch warnings due to
> changing an existing block comment in non-standard block-comment style.
>
> PATCH 11 has a checkpatch warning to check whether MAINTAINERS needs
> updating.  It doesn't.
>
> PATCH 11 might conflict with some other patch series that haven't been
> committed yet.
>
> 01) staging: comedi: add comedi_bytes_per_scan()
> 02) staging: comedi: comedi_fc: use comedi_bytes_per_scan()
> 03) staging: comedi: add comedi_inc_scan_progress()
> 04) staging: comedi: comedi_fc: use comedi_inc_scan_progress()
> 05) staging: comedi: add comedi_handle_events()
> 06) staging: comedi: comedi_fc: cfc_write_array_to_buffer() data is
>     const
> 07) staging: comedi: add comedi_write_array_to_buffer()
> 08) staging: comedi: comedi_fc.h: use comedi_write_array_to_buffer()
> 09) staging: comedi: add comedi_read_array_from_buffer()
> 10) staging: comedi: migrate copyrights from "comedi_fc.c"
> 11) staging: comedi: remove comedi_fc module
>
>  drivers/staging/comedi/Kconfig             |  31 -------
>  drivers/staging/comedi/comedi_buf.c        |  66 +++++++++++++++
>  drivers/staging/comedi/comedidev.h         |  11 +++
>  drivers/staging/comedi/drivers.c           |  95 +++++++++++++++++++++
>  drivers/staging/comedi/drivers/Makefile    |   1 -
>  drivers/staging/comedi/drivers/comedi_fc.c | 132 -----------------------------
>  drivers/staging/comedi/drivers/comedi_fc.h |  40 ++++++---
>  7 files changed, 201 insertions(+), 175 deletions(-)

Ian,

Other than I think the comedi_fc.c functions should be migrated to
comedi_buf.c instead of drivers.c I have not problems with this.

And, patch 11 does have a conflict with your "... use dma_alloc_coherent..."
patches.

But,

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>


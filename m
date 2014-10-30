Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934865AbaJ3V3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:29:19 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:44204
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933193AbaJ3V3S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:29:18 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/7] staging: comedi: enforce data transfer direction
Thread-Topic: [PATCH 0/7] staging: comedi: enforce data transfer direction
Thread-Index: AQHP9D8FLWXTM0MEU061vA6ls+Qm05xJKCHA
Date: Thu, 30 Oct 2014 21:29:17 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D882601818C@P3PWEX4MB008.ex4.secureserver.net>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
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

On Thursday, October 30, 2014 5:42 AM, Ian Abbott wrote:
> Most comedi subdevices that support asynchronous data acquisition
> commands only support data transfer in a single direction, as indicated
> by the `SDF_CMD_READ` and `SDF_CMD_WRITE` subdevice flags.  A few allow
> data transfer in either direction, but only a single direction at a
> time, as indicated by the `CMDF_WRITE` command flag in the `flags`
> member of the `struct comedi_cmd` from user-space used to set up the
> asynchronous command.  The `CMDF_WRITE` flag isn't commonly set for
> "write" commands if that is the only direction the subdevice supports.
>
> Since it would be useful for comedi to have a clear indication of which
> data transfer direction is being used, patch 1 forces the `CMDF_WRITE`
> command flag to the correct state if only one direction is supported.
> The flag can then be checked by comedi in the subdevice's local copy of
> the current command (in `s->async->cmd`) to determine the data transfer
> direction unambiguously.
>
> Patch 2 stops the "me4000" driver clobbering the command flags.
>
> Patch 3 removes some now redundant modification of the `CMDF_WRITE` flag
> in "ni_mio_common.c" (used by the "ni_pcimio", "ni_atmio" and
> "ni_mio_cs" drivers).
>
> Patches 4 and 5 disallow the read() and write() file operations if the
> subdevice has been set up with a command in the "write" or "read" data
> transfer direction respectively.
>
> Patch 6 changes the readable/writeable checks for the poll() file
> operation.  It already considers the file readable/writeable if
> read()/write() would fail with an error, so change it to check for
> "wrong direction" as one of the possible failures.
>
> Patch 7 makes the direction test in the handling of the `COMEDI_BUFINFO`
> ioctl (used to update buffer positions for mmapped buffers) less
> ambiguous.  The current test used the `SDF_CMD_READ` and `SDF_CMD_WRITE`
> subdevice flags to check the direction, which is ambiguous if both flags
> are set.  Update it to use the `CMDF_WRITE` command flag instead.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>


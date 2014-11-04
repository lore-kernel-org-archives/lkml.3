Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaKDSo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:44:58 -0500
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:35895
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbaKDSoy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:44:54 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] staging: comedi: per-file read/write subdevice
 choice
Thread-Topic: [PATCH 0/2] staging: comedi: per-file read/write subdevice
 choice
Thread-Index: AQHP+Fp0vSRiegNkkEmUitG4jnntuZxQy/Ew
Date: Tue, 4 Nov 2014 18:44:52 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8826023C34@P3PWEX4MB008.ex4.secureserver.net>
References: <1415124541-13648-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1415124541-13648-1-git-send-email-abbotti@mev.co.uk>
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

On Tuesday, November 04, 2014 11:09 AM, Ian Abbott wrote:
> This series of patches adds a couple of ioctl codes to the Comedi core
> to allow the current "read" and "write" subdevice to be changed after
> opening the comedi device.  The current read and write subdevice
> information is stored in file private data allocated for the lifetime of
> the file object, so the notion of current "read" and "write" subdevice
> is local to the file object and does not alter anything in the main
> control structure for the comedi device.  An extra level of indirection
> is now required to access the main control structure.
>
> I've tested the multiple "read" subdevice case using a modified version
> of the "comedi_test" module (modifying it to clone the existing AI
> subdevice), and a modified version of the "comedi_test" application
> (part of the "comedilib" installation) modified to use the new ioctls.
> There isn't any support in comedilib itself yet.
>
> 1) staging: comedi: prepare support for per-file read and write
>    subdevices
> 2) staging: comedi: add ioctls to set per-file read and write subdevice
>
>  drivers/staging/comedi/comedi.h          |   2 +
>  drivers/staging/comedi/comedi_compat32.c |   2 +
>  drivers/staging/comedi/comedi_fops.c     | 217 +++++++++++++++++++++++++++----
>  3 files changed, 196 insertions(+), 25 deletions(-)

Ian,

If I understand this correctly, the user can now open the "comediX"
device which will give then access to the default dev->read_subdev
and dev->write_subdev. They can then use the new ioctls to change
the read/write subdevice and use them without having the open the
"comediX_subdY" devices.

If this is correct it seems like a good idea.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Also, does this mean we can get rid of comedi_alloc_subdevice_minor()
and the "comediX_sudbY" stuff?

Regards,
Hartley


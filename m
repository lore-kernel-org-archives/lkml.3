Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaGaU2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:28:16 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:34320
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbaGaU2O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:28:14 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/18] staging: comedi: amplc_pci224: remove legacy stuff
Thread-Topic: [PATCH 00/18] staging: comedi: amplc_pci224: remove legacy
 stuff
Thread-Index: AQHPrMYV/m/cwd3ou0+rOyO4MPyZo5u6oc2g
Date: Thu, 31 Jul 2014 20:28:04 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F33D7B@P3PWEX4MB002.ex4.secureserver.net>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
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

On Thursday, July 31, 2014 6:48 AM, Ian Abbott wrote:
> The "amplc_pci224" driver retains a "legacy" attach mechanism via the
> `COMEDI_DEVCONFIG` ioctl and the comedi driver "attach" hook, but
> usually attaches PCI devices automatically via the comedi driver's
> "auto_attach" hook.  The legacy mechanism is only retained so that
> options can be passed via the ioctl to indicate how some hardware
> jumpers are set on the boards, which is used to set up the range tables.
> That's no use if the PCI device is attached automatically as the range
> tables will be set up according to the factory default jumper positions.
>
> Change the range tables to include all possible ranges, regardless of
> jumper positions.  Then there is no need to have options to control
> setting up the range tables and the "legacy" attach mechanism can be
> removed.
>
> Also, tidy the code up a bit.

Looks good.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Side note:

Now that the manual attach has been removed, you could also remove
the board information from the comedi_driver declaration.

Regards,
Hartley


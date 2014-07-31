Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaGaUot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:44:49 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:54368
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbaGaUos convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:44:48 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/18] staging: comedi: amplc_pci224: remove legacy stuff
Thread-Topic: [PATCH 00/18] staging: comedi: amplc_pci224: remove legacy
 stuff
Thread-Index: AQHPrMYV/m/cwd3ou0+rOyO4MPyZo5u6oc2ggAADTAA=
Date: Thu, 31 Jul 2014 20:44:07 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F34E2C@P3PWEX4MB002.ex4.secureserver.net>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D8825F33D7B@P3PWEX4MB002.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825F33D7B@P3PWEX4MB002.ex4.secureserver.net>
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

On Thursday, July 31, 2014 1:28 PM, Hartley Sweeten wrote:
> On Thursday, July 31, 2014 6:48 AM, Ian Abbott wrote:
>> The "amplc_pci224" driver retains a "legacy" attach mechanism via the
>> `COMEDI_DEVCONFIG` ioctl and the comedi driver "attach" hook, but
>> usually attaches PCI devices automatically via the comedi driver's
>> "auto_attach" hook.  The legacy mechanism is only retained so that
>> options can be passed via the ioctl to indicate how some hardware
>> jumpers are set on the boards, which is used to set up the range tables.
>> That's no use if the PCI device is attached automatically as the range
>> tables will be set up according to the factory default jumper positions.
>>
>> Change the range tables to include all possible ranges, regardless of
>> jumper positions.  Then there is no need to have options to control
>> setting up the range tables and the "legacy" attach mechanism can be
>> removed.
>>
>> Also, tidy the code up a bit.
>
> Looks good.
>
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Side note:
>
> Now that the manual attach has been removed, you could also remove
> the board information from the comedi_driver declaration.

Oops.. Just did a sparse build and get this:

drivers/staging/comedi/drivers/amplc_pci224.c:355:24: warning: obsolete array initializer, use C99 syntax
drivers/staging/comedi/drivers/amplc_pci224.c:363:24: warning: obsolete array initializer, use C99 syntax

The following patch fixes it, or you fold it into patch 15.

Regards,
Hartley

---

From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Wed, 30 Jul 2014 10:50:11 -0700
Subject: [PATCH] staging: comedi: amplc_pci224: fix obsolete array initializer

Fix the sparse warnings:
warning: obsolete array initializer, use C99 syntax

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 21f06bb..2170e5e 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -352,7 +352,7 @@ struct pci224_board {
 };
 
 static const struct pci224_board pci224_boards[] = {
-	[pci224_model] {
+	[pci224_model] = {
 		.name		= "pci224",
 		.ao_chans	= 16,
 		.ao_bits	= 12,
@@ -360,7 +360,7 @@ static const struct pci224_board pci224_boards[] = {
 		.ao_hwrange	= &hwrange_pci224[0],
 		.ao_range_check	= &range_check_pci224[0],
 	},
-	[pci234_model] {
+	[pci234_model] = {
 		.name		= "pci234",
 		.ao_chans	= 4,
 		.ao_bits	= 16,

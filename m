Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaCFRvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:51:42 -0500
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:32924
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512AbaCFRvl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:51:41 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] Staging: comedi: addi-data: tidy up counter
 register map defines in hwdrv_apci1564.c
Thread-Topic: [PATCH 5/5] Staging: comedi: addi-data: tidy up counter
 register map defines in hwdrv_apci1564.c
Thread-Index: AQHPOQ1n0HikxxkhgUC6RAH1f09/EJrUVnrA
Date: Thu, 6 Mar 2014 17:51:40 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DA44FA@P3PWEX4MB008.ex4.secureserver.net>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
 <1394090783-8030-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1394090783-8030-1-git-send-email-chase.southwood@yahoo.com>
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

On Thursday, March 06, 2014 12:26 AM, Chase Southwood wrote:
> This patch for hwdrv_apci1564.c fixes the register map defines for the
> digital input registers such that they are all the real offsets to each
> register, rather than a mix of real offsets and adders to those offsets.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 101 +++++++++------------
>  1 file changed, 44 insertions(+), 57 deletions(-)

This one is incomplete and breaks the build.

  CC [M]  drivers/staging/comedi/drivers/addi_apci_1564.o
In file included from drivers/staging/comedi/drivers/addi_apci_1564.c:11:0:
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c: In function 'i_APCI1564_ConfigTimerCounterWatchdog':
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:352:4: error: 'APCI1564_TCW_PROG' undeclared (first use in this function)
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:352:4: note: each undeclared identifier is reported only once for each function it appears in
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:359:4: error: 'APCI1564_TCW_RELOAD_VALUE' undeclared (first use in this function)
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c: In function 'i_APCI1564_StartStopWriteTimerCounterWatchdog':
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:463:19: error: 'APCI1564_TCW_PROG' undeclared (first use in this function)
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c: In function 'i_APCI1564_ReadTimerCounterWatchdog':
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:526:4: error: 'APCI1564_TCW_SYNC_ENABLEDISABLE' undeclared (first use in this function)
drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:529:19: error: 'APCI1564_TCW_TRIG_STATUS' undeclared (first use in this function)
make[4]: *** [drivers/staging/comedi/drivers/addi_apci_1564.o] Error 1
make[3]: *** [drivers/staging/comedi/drivers] Error 2
make[2]: *** [drivers/staging/comedi] Error 2
make[1]: *** [drivers/staging] Error 2
make: *** [drivers] Error 2

Be sure to do a build after each patch to make sure it works.

Regards,
Hartley

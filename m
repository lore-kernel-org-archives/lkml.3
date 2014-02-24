Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaBXK1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:27:52 -0500
Received: from mx0.aculab.com ([213.249.233.131]:55314 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752091AbaBXK1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:27:50 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Joe Perches'" <joe@perches.com>,
        Thomas Winischhofer <thomas@winischhofer.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: sisusb: Use static const, fix typo
Thread-Topic: sisusb: Use static const, fix typo
Thread-Index: AQHPL3HCyEctK09QYUO12nIH2aQdjprENdvA
Date: Mon, 24 Feb 2014 10:26:53 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6C9771@AcuExch.aculab.com>
References: <1393034412.3627.11.camel@joe-AO722>
In-Reply-To: <1393034412.3627.11.camel@joe-AO722>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches
> Reduce text a bit by using static const.

If you want to save a few bytes remove the pointers.
(and the fixed RAM text to get below 7 chars).
eg:

> -	const char *ramtypetext2[] = {	"SDR SDRAM", "SDR SGRAM",
> -					"DDR SDRAM", "DDR SGRAM" };

	static const char ramtypetext2[8][] = {
		"SDR SD", "SDR SG", "DDR SD", "DDR SG"

...
> -	dev_info(&sisusb->sisusb_dev->dev, "%dMB %s %s, bus width %d\n", (sisusb->vramsize >> 20),
> ramtypetext1,
> -			ramtypetext2[ramtype], bw);

	dev_info(&sisusb->sisusb_dev->dev, "%dMB %s %sRAM, bus width %d\n",
		 sisusb->vramsize >> 20, ramtypetext1, ramtypetext2[ramtype],
		 bw);

	David




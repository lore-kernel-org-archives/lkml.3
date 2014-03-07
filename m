Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaCGPM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:12:56 -0500
Received: from mx0.aculab.com ([213.249.233.131]:33687 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752752AbaCGPMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:53 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH 2/2] Revert "USBNET: ax88179_178a: enable tso if usb
 host supports sg dma"
Thread-Topic: [PATCH 2/2] Revert "USBNET: ax88179_178a: enable tso if usb
 host supports sg dma"
Thread-Index: AQHPOhW/7Dk26KmSaUac+4xvwJwpV5rVuasQ
Date: Fri, 7 Mar 2014 15:12:15 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6D770F@AcuExch.aculab.com>
References: <1394204818-25323-1-git-send-email-mathias.nyman@linux.intel.com>
 <1394204818-25323-3-git-send-email-mathias.nyman@linux.intel.com>
In-Reply-To: <1394204818-25323-3-git-send-email-mathias.nyman@linux.intel.com>
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

From: Mathias Nyman
> This reverts commit 3804fad45411b48233b48003e33a78f290d227c8.
> 
> This commit, together with commit 247bf557273dd775505fb9240d2d152f4f20d304
> "xhci 1.0: Limit arbitrarily-aligned scatter gather." were
> origially added to get xHCI 1.0 hosts and usb ethernet ax88179_178a devices
> working together with scatter gather. xHCI 1.0 hosts pose some requirement on how transfer
> buffers are aligned, setting this requirement for 1.0 hosts caused USB 3.0 mass
> storage devices to fail more frequently.

This patch doesn't need to be reverted.
Provided the xhci driver doesn't set the flag to say that arbitrary scatter
gather is supported (ie usb_device_no_sg_constraint(dev->udev)) is false)
the ax88179_178a driver won't request transmits that need fragmenting.

There is a separate issue in that it does request receives that need
fragmenting.
However if the fragmented receives end up being split by a LINK TRB
the device driver recovers.
The ax88179 hardware doesn't recover when a tx is split.

	David




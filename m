Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaF0IJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:09:05 -0400
Received: from mx0.aculab.com ([213.249.233.131]:45804 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752462AbaF0II7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:08:59 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Chen, Alvin'" <alvin.chen@intel.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
CC: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Sergei Shtylyov'" <sergei.shtylyov@cogentembedded.com>,
        "'Boon Leong Ong'" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
Thread-Topic: [PATCH v2] USB: ehci-pci: USB host controller support for
 Intel Quark X1000
Thread-Index: AQHPkbfEDtgm/h3R10ChmJIAlPb4S5uETZIAgAAA9ICAAEqUIA==
Date: Fri, 27 Jun 2014 08:08:09 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17267F31@AcuExch.aculab.com>
References: <1403868276-12558-1-git-send-email-alvin.chen@intel.com>
 <1403868276-12558-2-git-send-email-alvin.chen@intel.com>
 <000401cf91c0$e3a98600$aafc9200$%han@samsung.com>
 <000601cf91c1$5d25fcc0$1771f640$%han@samsung.com>
In-Reply-To: <000601cf91c1$5d25fcc0$1771f640$%han@samsung.com>
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

From: Jingoo Han

...
> /* The maximal threshold value is 0x80, which means 512 bytes */
> #define EHCI_THRESHOLD_512BYTES		0x80
> #define EHCI_THRESHOLD_508BYTES		0x79

It would be better to define these using expressions. So:
#define EHCI_THRESHOLD_512BYTES		(512u / 8u)
#define EHCI_THRESHOLD_508BYTES		(508u / 8u)

Then you might decide to use:
#define EHCI_THRESHOLD(size) ((size) / 8u)

Then realise that the names are not generic EHCI, so need some
driver-specific prefix (for namespace reasons).

And that the defines are probably limit values, and should
be named as such.

	David




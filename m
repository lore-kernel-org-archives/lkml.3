Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaBZQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:29:25 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.144]:13225 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbaBZQ3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:29:24 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-14.tower-179.messagelabs.com!1393432160!28752733!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 26 Feb 2014 17:29:20 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>
CC: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH v3 0/3] drivers/mcb: Bus support for MEN Chameleon Bus
Date: Wed, 26 Feb 2014 17:29:04 +0100
Message-ID: <1393432147-31355-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.8.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set introduces the MEN Chameleon Bus (MCB). MCB is not a "real" bus
like PCI, but a header section in the beginning of the FPGAs memory. This
headers are used to describe the IP-Cores inside that FPGA.

The MCB driver parses this header section and creates devices for the single
IP-Cores. It also provides an interface for device drivers to access these
resources.

Currently the bus driver has some limitations, for example IRQ handling or
memory mapped memory support, which will be addressed once drivers that need
these features are submitted.

As a first driver using the new bus, men_z188_adc.c, an IIO ADC driver, is
included in this patch-set.

Johannes Thumshirn (3):
  drivers: Introduce MEN Chameleon Bus
  mcb: Add PCI carrier for MEN Chameleon Bus
  iio: adc: Add MEN 16z188 ADC driver

 MAINTAINERS                     |   6 +
 drivers/Kconfig                 |   2 +
 drivers/Makefile                |   1 +
 drivers/iio/adc/Kconfig         |  10 +
 drivers/iio/adc/Makefile        |   1 +
 drivers/iio/adc/men_z188_adc.c  | 171 +++++++++++++++++
 drivers/mcb/Kconfig             |  29 +++
 drivers/mcb/Makefile            |   7 +
 drivers/mcb/mcb-core.c          | 414 ++++++++++++++++++++++++++++++++++++++++
 drivers/mcb/mcb-internal.h      | 118 ++++++++++++
 drivers/mcb/mcb-parse.c         | 159 +++++++++++++++
 drivers/mcb/mcb-pci.c           | 114 +++++++++++
 include/linux/mcb.h             | 119 ++++++++++++
 include/linux/mod_devicetable.h |   5 +
 14 files changed, 1156 insertions(+)
 create mode 100644 drivers/iio/adc/men_z188_adc.c
 create mode 100644 drivers/mcb/Kconfig
 create mode 100644 drivers/mcb/Makefile
 create mode 100644 drivers/mcb/mcb-core.c
 create mode 100644 drivers/mcb/mcb-internal.h
 create mode 100644 drivers/mcb/mcb-parse.c
 create mode 100644 drivers/mcb/mcb-pci.c
 create mode 100644 include/linux/mcb.h

--
1.8.5.4


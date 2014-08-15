Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaHOWJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:09:45 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:58376
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750848AbaHOWJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:09:44 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <stuart.yoder@freescale.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/4] drivers/bus: Freescale Management Complex bus driver patch series
Date: Fri, 15 Aug 2014 17:09:33 -0500
Message-ID: <1408140577-24982-1-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(81342001)(92566001)(79102001)(106466001)(2351001)(4396001)(77982001)(68736004)(85306004)(83072002)(46102001)(44976005)(48376002)(80022001)(50226001)(92726001)(2371004)(20776003)(81542001)(74502001)(105606002)(229853001)(62966002)(107046002)(99396002)(36756003)(93916002)(64706001)(97736001)(87936001)(77156001)(110136001)(31966008)(6806004)(47776003)(76482001)(83322001)(85852003)(50986999)(86362001)(50466002)(81156004)(104166001)(21056001)(26826002)(95666004)(87286001)(104016003)(84676001)(89996001)(69596002)(102836001)(88136002)(74662001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0740;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0304E36CA3
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces Linux support for the Freescale
Management Complex (fsl-mc) hardware.

The fsl-mc is a hardware resource manager that manages specialized
hardware objects used in network-oriented packet processing
applications.  After the fsl-mc block is enabled, pools of hardware
resources are available, such as queues, buffer poools, I/O
interfaces.  These resources are building blocks that can be
used to create functional hardware objects such as network
interfaces, crypto accelerator instances, or L2 switches.

All the fsl-mc managed hardware resources/objects are represented in
a physical grouping mechanism called a 'container' or DPRC (data
path resource container).

>From the point of view of an OS, a DPRC functions similar to a plug
and play bus.  Using fsl-mc commands software can enumerate the
contents of the DPRC discovering the hardware objects present
and binding them to drivers.  Hardware objects can be created
and removed dynamically, providing hot pluggability of the hardware
objects.

Software contexts interact with the fsl-mc by sending commands through
a memory mapped hardware interface called an "MC portal". Every
fsl-mc object type has a command set to manage the objects. Key
DPRC commands include:
   -create/destroy a DPRC
   -enumerate objects and resource pools in the DPRC, including
    identifying mappable regions and the number of IRQs an object
    may have
   -IRQ configuration
   -move objects/resources between DPRCs
   -connecting objects (e.g. connecting a network interface to
    an L2 switch port)
   -reset

Patch 1 contains a minimal set of low level functions to send an
d receive commands to the fsl-mc. It includes support for basic
management commands and commands to manipulate DPRC objects.

Patch 2 contains a platform device driver that sets up and registers
the basic bus infrastructure including support for adding/removing
devices, register/unregister of drivers, and bus match support
to bind devices to drivers.

Patch 3 contains an driver that manages DPRC objects (the
container that holds the hardware resources). This driver
functions as a bus controller and handles enumeration
of the objects in the container and hotplug events.

Patch 4 contains the update to the MAINTAINERS file.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3AKGVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:21:15 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:60827 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3AKGVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:21:11 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 0/4] switch arc-uart to devicetree based probing
Date: Fri, 11 Jan 2013 11:50:19 +0530
Message-ID: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As part of converting ARC Port to devicetree infrastructure, the following
series converts the arc-uart driver to DT.

* The first patch is a bug-fix which showed up in the process as DT based
  platform devices by default have -ve id
* Next two prepare the driver for forthcoming DT changes.
* Last one contains the DT bindings and driver using those.

Couple of points worth mentioning:
* The earlyprintk portion of driver still relies on static platform data
  we would need some earlyprintk handling in of_fdt_* to clean it up properly
* Two of the three platform data instances are now retrieved from DT.
  However one still needs to be dynamically passed by platform (using
  of_dev_auxdata) as we want to run same image in simulator and hardware

Tested on in-works ARC 3.8 port.

P.S. Greg, can this be treated as a bug-fix for 3.8

Thx,
-Vineet

Vineet Gupta (4):
  serial/arc-uart: Don't index with -ve platform_device->id
  serial/arc-uart: split probe from probe_earlyprintk
  serial/arc-uart: platform_data order changed
  serial/arc-uart: switch to devicetree based probing

 .../devicetree/bindings/tty/serial/arc-uart.txt    |   26 ++++++
 drivers/tty/serial/arc_uart.c                      |   95 ++++++++++++++------
 2 files changed, 94 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/arc-uart.txt

-- 
1.7.4.1


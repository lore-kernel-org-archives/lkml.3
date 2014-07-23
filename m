Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbaGWPdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:33:15 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:36455 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbaGWPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:33:12 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/2] serial: 8250_dw: optional reset control and deferred probe support
Date: Wed, 23 Jul 2014 23:33:05 +0800
Message-Id: <1406129587-24668-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This series adds optional reset control and deferred probing support
to 8250_dw. These are required to support the UARTs on sun6i/sun8i.
They were originally part of my sun8i PRCM series. The other parts
of that series have been merged already. It would be really nice
if we could get these 2 in as well.

Patch 1 adds optional reset control support to the 8250_dw, which
is used by sun6i and sun8i platforms. Till now, this wasn't needed
from a working standpoint, as the bootloader de-asserts the reset
control on the console UART for us. However, during the development
of the sun8i patches, I noticed other UARTs wouldn't work. Also the
new sun6i A31 Hummingbird has multiple UARTs available, which would
require this patch.

Patch 2 adds deferred probing to 8250_dw. In my case, even though
the clocks and reset controller "devices" were registered before
the UART, the 8250_dw driver binded with the UART devices before
the clocks and resets were available. This resulted in the 8250_dw
driver failing. I only tested the R_UART device.

Patch 2 also does proper cleanup in the event that probing failed.

Maxime, I dropped your Acked-by because I added the cleanup code
path.

Changes since v4:
  - Rebased onto tty-next (4847914)
  - Do proper cleanup in the probe function if errors are encountered.

No changes before v4.


Cheers
ChenYu


Chen-Yu Tsai (2):
  serial: 8250_dw: Add optional reset control support
  serial: 8250_dw: Add support for deferred probing

 .../bindings/serial/snps-dw-apb-uart.txt           |  1 +
 drivers/tty/serial/8250/8250_dw.c                  | 50 +++++++++++++++++++---
 2 files changed, 44 insertions(+), 7 deletions(-)

-- 
2.0.1


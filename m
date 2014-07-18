Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaGRMx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:53:27 -0400
Received: from mail.neotion.com ([5.39.84.84]:52351 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaGRMx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:53:26 -0400
Message-ID: <53C91653.5030105@neotion.com>
Date: Fri, 18 Jul 2014 14:42:59 +0200
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
Organization: Neotion
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] net: macb: Handle RX errors
X-Enigmail-Version: 1.6
OpenPGP: id=1166F485
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On our hardware, the MACB connected to a heavilly used AXI bus, fails to
correctly write RX descriptors.

This leds to RX ring errors that can be managed.

These patchs add RX error management according to the Cadence MACB User Guide.

The first patch separates the RX and TX rings init in order to reuse the RX ring init.

v2: fix multiple assignments in first patch, fix checkpatch errors in second patch.

Neil Armstrong (2):
  net: macb: Separate rx and tx ring init function
  net: macb: Handle errors in RX path

 drivers/net/ethernet/cadence/macb.c |   90 +++++++++++++++++++++++++++++-----
 drivers/net/ethernet/cadence/macb.h |    3 +-
 2 files changed, 78 insertions(+), 15 deletions(-)



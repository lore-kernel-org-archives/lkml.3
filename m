Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676AbaGRJvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:51:44 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57754 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556AbaGRJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:51:38 -0400
Message-ID: <53C8EE27.3060201@gmail.com>
Date: Fri, 18 Jul 2014 11:51:35 +0200
From: Neil Armstrong <superna9999@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] net: macb: Handle RX errors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On our hardware, the MACB connected to a heavilly used AXI bus, fails to
correctly write RX descriptors.

This leds to RX ring errors that can be managed.

These patchs add RX error management according to the Cadence MACB User Guide.

The first patch separates the RX and TX rings init in order to reuse the RX ring init.

Neil Armstrong (2):
  net: macb: Separate rx and tx ring init function
  net: macb: Handle errors in RX path

 drivers/net/ethernet/cadence/macb.c |   88 +++++++++++++++++++++++++++++------
 drivers/net/ethernet/cadence/macb.h |    3 +-
 2 files changed, 76 insertions(+), 15 deletions(-)

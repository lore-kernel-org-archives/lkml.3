Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaKJUfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:35:17 -0500
Received: from ring0.de ([5.45.105.125]:52901 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaKJUfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:35:14 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: linuxtv.org]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 0/4] [media] si4713 DT binding
Date: Mon, 10 Nov 2014 21:34:40 +0100
Message-Id: <1415651684-3894-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the third revision of the si4713 radio transmitter DT support
patchset needed for the Nokia N900.

Changes since PATCHv2:
 * Dropped patches 1-4, which have been accepted
 * Patch 1 has been updated according to Sakari's comments
 * Patch 3-4 are unchanged

Apart from that you marked Patch 2 as not applicable last time [0].
Normally the DT binding documentation is taken by the subsystem
maintainer together with the driver changes. You can see the details
in Documentation/devicetree/bindings/submitting-patches.txt

For Patch 3 feedback from Tony is needed. I think the simplest solution
would be to merge it via the media tree (assuming, that the boardcode
is not yet removed in 3.19).

[0] https://patchwork.linuxtv.org/patch/26506/

-- Sebastian

Sebastian Reichel (4):
  [media] si4713: add device tree support
  [media] si4713: add DT binding documentation
  ARM: OMAP2: RX-51: update si4713 platform data
  [media] si4713: cleanup platform data

 Documentation/devicetree/bindings/media/si4713.txt | 30 ++++++++++
 arch/arm/mach-omap2/board-rx51-peripherals.c       | 69 ++++++++++------------
 drivers/media/radio/si4713/radio-platform-si4713.c | 28 ++-------
 drivers/media/radio/si4713/si4713.c                | 31 +++++++++-
 drivers/media/radio/si4713/si4713.h                |  6 ++
 include/media/radio-si4713.h                       | 30 ----------
 include/media/si4713.h                             |  4 +-
 7 files changed, 103 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/si4713.txt
 delete mode 100644 include/media/radio-si4713.h

-- 
2.1.1


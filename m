Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab3KMVwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:52:24 -0500
Received: from multi.imgtec.com ([194.200.65.239]:20888 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3KMVwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:52:07 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <devicetree@vger.kernel.org>,
        <linux-metag@vger.kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 0/2] add specified-clock DT binding
Date: Wed, 13 Nov 2013 21:49:58 +0000
Message-ID: <1384379400-24776-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_13_21_52_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The frequency of some fixed rate external oscillators on some SoCs (for
example TZ1090's XTAL1) are specified by the board using pull-ups and
pull-downs of configuration pins which are automatically latched on
reset and available in an SoC register, so that the boot ROM and OS can
automatically discover it.

The first patch adds a separate binding for these clocks to describe how
to discover the frequency. I could easily have extended the fixed-rate
binding instead, but there'd be no properties in common except the
standard common clock properties so it seemed like it deserved a
separate binding. I'm open to arguments to the contrary or better
compatible string names though.

The second patch implements the binding, which sets up a normal fixed
rate clock just like the normal fixed-clock binding except it discovers
the frequency instead of using the clock-frequency property.

Changes in v2:
 * Split out bindings patch for ease of review.
 * Rewrite to use a fixed clock instead of an entirely new clock type.
 * Borrow bit-mask and bit-shift bindings from Mike's mux clock binding
   proposals.

James Hogan (2):
  dt: binding: add specified-clock for discoverable rate clocks
  clk-fixed-rate: support specified-clock binding

 .../devicetree/bindings/clock/specified-clock.txt  | 38 ++++++++++++++++
 drivers/clk/clk-fixed-rate.c                       | 51 ++++++++++++++++++++++
 include/linux/clk-provider.h                       |  1 +
 3 files changed, 90 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/specified-clock.txt

-- 
1.8.1.2



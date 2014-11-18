Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbaKSAAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 19:00:19 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48419 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029AbaKSAAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 19:00:16 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v3 0/2] add specified-clock DT binding
Date: Tue, 18 Nov 2014 23:59:45 +0000
Message-Id: <1416355187-11606-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resurrecting a year old patchset I'm still interested in, which I didn't
get any review comments for with v2.

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

Changes in v3:
 * Remove unused & unimplemented gpios property. Not sure why it was
   there in the first place.

Changes in v2:
 * Split out bindings patch for ease of review.
 * Rewrite to use a fixed clock instead of an entirely new clock type.
 * Borrow bit-mask and bit-shift bindings from Mike's mux clock binding
   proposals.

James Hogan (2):
  dt: binding: add specified-clock for discoverable rate clocks
  clk-fixed-rate: support specified-clock binding

 .../devicetree/bindings/clock/specified-clock.txt  | 37 ++++++++++++++++
 drivers/clk/clk-fixed-rate.c                       | 51 ++++++++++++++++++++++
 include/linux/clk-provider.h                       |  1 +
 3 files changed, 89 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/specified-clock.txt

-- 
2.0.4


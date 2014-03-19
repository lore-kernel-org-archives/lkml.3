Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256AbaCSPMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:12:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45263 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935AbaCSPML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:12:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, devicetree@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 0/3] Parse OF graph and create backlinks internally
Date: Wed, 19 Mar 2014 16:12:01 +0100
Message-Id: <1395241924-9675-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while I'm eagerly awaiting the outcome of the current situation regarding the
"Move device tree graph parsing helpers to drivers/of" series, here is a draft
implementation that parses the whole device tree into a separate graph
structure, creating the backlinks internally. This way it doesn't matter to
the code in which direction the phandle links in the device tree are pointing.
The current code assumes a static device tree and doesn't handle runtime
changes at all.

I've also added two helpers to iterate over all ports of a device, and to
obtain a specific port by its id (as contained in the 'reg' property).

These patches are based directly on top of the previous series, which still
can be found at:
	git://git.pengutronix.de/git/pza/linux.git topic/of-graph

Philipp Zabel (3):
  of: Parse OF graph into graph structure
  of: Add OF graph helper to get a specific port by id
  of: Add OF graph helpers to iterate over ports

 drivers/of/base.c        | 476 +++++++++++++++++++++++++++++++++++++++--------
 include/linux/of_graph.h |  31 +++
 2 files changed, 430 insertions(+), 77 deletions(-)

-- 
1.9.0


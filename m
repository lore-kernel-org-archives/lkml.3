Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbaGWJlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:41:37 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35896 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599AbaGWJld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:41:33 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] staging: comedi: ni_65xx: edge detection changes
Date: Wed, 23 Jul 2014 10:41:17 +0100
Message-Id: <1406108481-23910-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add partial support for INSN_CONFIG_DIGITAL_TRIG as an alternative to
INSN_CONFIG_CHANGE_NOTIFY (with the advantage that more than the first 32
channels are supported), and initialize the edge detection registers.

1) staging: comedi: ni_65xx: add ni_65xx_num_ports()
2) staging: comedi: ni_65xx: refactor edge detection configuration
3) staging: comedi: ni_65xx: support INSN_CONFIG_DIGITAL_TRIG
4) staging: comedi: ni_65xx: disable edge detection on initialization

 drivers/staging/comedi/drivers/ni_65xx.c | 125 +++++++++++++++++++++++--------
 1 file changed, 94 insertions(+), 31 deletions(-)

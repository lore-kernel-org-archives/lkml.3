Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3KSWu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:50:58 -0500
Received: from seketeli.net ([91.121.166.71]:39975 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3KSWu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:50:56 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 0/1] usb: fix musb gadget to enable OTG mode conditionally
Date: Tue, 19 Nov 2013 23:18:19 +0100
Message-Id: <1384899500-30307-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While working on an musb glue layer for an embedded USB device
controller, I encountered the following issue.

The aforementioned UDC is not OTG capable, so I built the musb driver
as gadget only and noticed that the musb_gadget code was trying to
enable the OTG side of the controller, which does exist in
silicon. While testing the glue layer code, the musb core was then
trying to use Host Negotiation Protocol, which induces a panic.

The patch that comes as a follow-up of this message is an attempt to
fix the issue before submitting the glue layer code which is still in
progress; v2 only fixes the Cc: list which wasn't picked up at first
by git-send-email, sorry for the inconvenience.

Changes were rebased on top of Felipe Balbi's USB Subsystem master
branch, built successfully and tested on device without reproducing
the issue.

The following changes since commit 3fc848d423216db97a4db9b4b9633561244e100a:

  usb: fix musb gadget to enable OTG mode conditionally

are available in the git repository at:

  git://seketeli.fr/~apelete/linux-usb.git musb-hnp-fix

Apelete Seketeli (1):
  usb: fix musb gadget to enable OTG mode conditionally

 drivers/usb/musb/musb_gadget.c |    4 ++++
 1 file changed, 4 insertions(+)

-- 
1.7.10.4


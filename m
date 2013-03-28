Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3C1Ssd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:48:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab3C1Ssb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:48:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/2] xhci: Use ilog2() rather than __ffs() for calculating
 SEGMENT_SHIFT
To: sarah.a.sharp@linux.intel.com
From: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 18:48:28 +0000
Message-ID: <20130328184827.29679.62426.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ilog2() rather than __ffs() for calculating SEGMENT_SHIFT as ilog2() can
be worked out at compile time, whereas __ffs() must be calculated at runtime.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-usb@vger.kernel.org
---

 drivers/usb/host/xhci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 2c510e4..558ba50 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1235,7 +1235,7 @@ union xhci_trb {
 /* Allow two commands + a link TRB, along with any reserved command TRBs */
 #define MAX_RSVD_CMD_TRBS	(TRBS_PER_SEGMENT - 3)
 #define SEGMENT_SIZE		(TRBS_PER_SEGMENT*16)
-#define SEGMENT_SHIFT		(__ffs(SEGMENT_SIZE))
+#define SEGMENT_SHIFT		(ilog2(SEGMENT_SIZE))
 /* TRB buffer pointers can't cross 64KB boundaries */
 #define TRB_MAX_BUFF_SHIFT		16
 #define TRB_MAX_BUFF_SIZE	(1 << TRB_MAX_BUFF_SHIFT)


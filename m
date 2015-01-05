Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbbAESAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:00:47 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:55186 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932216AbbAER4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:17 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 34/45] staging: comedi: pcl730: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:55:02 +0000
Message-Id: <1420480513-14765-35-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
References: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the "Devices:" line in the comedi "driver" comment to conform to
the usual comedi format for this line.  The line should be a
comma-separated list where the first item is in the following format:

  [Manufacturer] BOARD-NAME (comedi-board-name)

The "[Manufacturer]" and/or "(comedi-board-name)" parts may be omitted
from following items, in which case the parts from the preceding item
are used.  The "Devices:" line may be continued continued over several
lines by using one or more spaces at the start of each continuation line
(not counting the space after the "*" in the block comment).

Group boards from the same manufacturer together on the "Devices:" line
to avoid repeating the "[Manufacturer]" tag unnecessarily.

Also fix a couple of typos in the board names on the "Devices:" line:
"p16r16dio" was used twice, but one of them should be "p8r8dio";
"prearl-mm-p" should be "pearl-mm-p".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/pcl730.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index a6c5770..ce958ee 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -7,19 +7,12 @@
 /*
  * Driver: pcl730
  * Description: Advantech PCL-730 (& compatibles)
- * Devices: (Advantech) PCL-730 [pcl730]
- *	    (ICP) ISO-730 [iso730]
- *	    (Adlink) ACL-7130 [acl7130]
- *	    (Advantech) PCM-3730 [pcm3730]
- *	    (Advantech) PCL-725 [pcl725]
- *	    (ICP) P8R8-DIO [p16r16dio]
- *	    (Adlink) ACL-7225b [acl7225b]
- *	    (ICP) P16R16-DIO [p16r16dio]
- *	    (Advantech) PCL-733 [pcl733]
- *	    (Advantech) PCL-734 [pcl734]
- *	    (Diamond Systems) OPMM-1616-XT [opmm-1616-xt]
- *	    (Diamond Systems) PEARL-MM-P [prearl-mm-p]
- *	    (Diamond Systems) IR104-PBF [ir104-pbf]
+ * Devices: [Advantech] PCL-730 (pcl730), PCM-3730 (pcm3730), PCL-725 (pcl725),
+ *   PCL-733 (pcl733), PCL-734 (pcl734),
+ *   [ADLink] ACL-7130 (acl7130), ACL-7225b (acl7225b),
+ *   [ICP] ISO-730 (iso730), P8R8-DIO (p8r8dio), P16R16-DIO (p16r16dio),
+ *   [Diamond Systems] OPMM-1616-XT (opmm-1616-xt), PEARL-MM-P (pearl-mm-p),
+ *   IR104-PBF (ir104-pbf),
  * Author: José Luis Sánchez (jsanchezv@teleline.es)
  * Status: untested
  *
-- 
2.1.4


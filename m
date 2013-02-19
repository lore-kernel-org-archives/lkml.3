Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab3BSJJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:09:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47922 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab3BSJJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:09:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Feb 2013 10:09:07 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>
Subject: [PATCH linux-next v2] firewire: fw_device_init: 'minor' may be used
 uninitialized
Message-ID: <20130219100907.5dff3124@stein>
In-Reply-To: <1361222676-113069-1-git-send-email-tim.gardner@canonical.com>
References: <1361222343-112898-1-git-send-email-tim.gardner@canonical.com>
	<1361222676-113069-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Mon, 18 Feb 2013 14:24:36 -0700
From: Tim Gardner <tim.gardner@canonical.com>

'firewire: convert to idr_alloc()' accidentally orphaned 'minor'.

drivers/firewire/core-device.c: In function ‘fw_device_init’:
drivers/firewire/core-device.c:1029:24: warning: ‘minor’ may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Andrew, please send this on together with the other idr patches,
or even merge this into patch "firewire: convert to idr_alloc()" before
the latter reaches upstream.

 drivers/firewire/core-device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index b946330..03ce7d9 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -1017,10 +1017,11 @@ static void fw_device_init(struct work_struct *work)
 
 	fw_device_get(device);
 	down_write(&fw_device_rwsem);
-	ret = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS, GFP_KERNEL);
+	minor = idr_alloc(&fw_device_idr, device, 0, 1 << MINORBITS,
+			GFP_KERNEL);
 	up_write(&fw_device_rwsem);
 
-	if (ret < 0)
+	if (minor < 0)
 		goto error;
 
 	device->device.bus = &fw_bus_type;


-- 
Stefan Richter
-=====-===-= --=- =--==
http://arcgraph.de/sr/

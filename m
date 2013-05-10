Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3EJOc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:32:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57200 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755533Ab3EJOVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:32 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mika Kuoppala" <mika.kuoppala@intel.com>,
        "Mika Kuoppala" <mika.kuoppala@linux.intel.com>,
        "Dave Airlie" <airlied@redhat.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.642884054@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [052/118] fbcon: when font is freed, clear also vc_font.data
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Kuoppala <mika.kuoppala@linux.intel.com>

commit e6637d5427d2af9f3f33b95447bfc5347e5ccd85 upstream.

commit ae1287865f5361fa138d4d3b1b6277908b54eac9
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jan 24 16:12:41 2013 +1000

    fbcon: don't lose the console font across generic->chip driver switch

uses a pointer in vc->vc_font.data to load font into the new driver.
However if the font is actually freed, we need to clear the data
so that we don't reload font from dangling pointer.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=892340
Signed-off-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/console/fbcon.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1229,6 +1229,8 @@ static void fbcon_deinit(struct vc_data
 finished:
 
 	fbcon_free_font(p, free_font);
+	if (free_font)
+		vc->vc_font.data = NULL;
 
 	if (!con_is_bound(&fb_con))
 		fbcon_exit();


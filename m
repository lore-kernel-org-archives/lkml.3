Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007Ab3EGABp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:01:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab3EFW5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:57:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 19/63] fbcon: when font is freed, clear also vc_font.data
Date: Mon,  6 May 2013 15:55:57 -0700
Message-Id: <20130506225319.661721079@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/console/fbcon.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1228,6 +1228,8 @@ static void fbcon_deinit(struct vc_data
 finished:
 
 	fbcon_free_font(p, free_font);
+	if (free_font)
+		vc->vc_font.data = NULL;
 
 	if (!con_is_bound(&fb_con))
 		fbcon_exit();



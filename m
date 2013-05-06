Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab3EFXIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:08:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab3EFW7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:59:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 14/46] fbcon: when font is freed, clear also vc_font.data
Date: Mon,  6 May 2013 15:58:20 -0700
Message-Id: <20130506225822.190147853@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1229,6 +1229,8 @@ static void fbcon_deinit(struct vc_data
 finished:
 
 	fbcon_free_font(p, free_font);
+	if (free_font)
+		vc->vc_font.data = NULL;
 
 	if (!con_is_bound(&fb_con))
 		fbcon_exit();



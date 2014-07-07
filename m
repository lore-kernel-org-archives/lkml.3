Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaGHBPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:15:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaGGXxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.15 025/122] vgaswitcheroo: switch the mux to the igp on power down when runpm is enabled
Date: Mon,  7 Jul 2014 16:56:27 -0700
Message-Id: <20140707235735.001659499@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f2bc561610962693be61425cf913778586d8f9c1 upstream.

Avoids blank screens on muxed systems when runpm is active.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=75917

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/vga/vga_switcheroo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -623,7 +623,8 @@ static int vga_switcheroo_runtime_suspen
 	ret = dev->bus->pm->runtime_suspend(dev);
 	if (ret)
 		return ret;
-
+	if (vgasr_priv.handler->switchto)
+		vgasr_priv.handler->switchto(VGA_SWITCHEROO_IGD);
 	vga_switcheroo_power_switch(pdev, VGA_SWITCHEROO_OFF);
 	return 0;
 }



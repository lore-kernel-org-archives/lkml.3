Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab3B0Aiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:38:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab3BZX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Ming Lei <ming.lei@canonical.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 148/150] usb: musb: core: fix failure path
Date: Tue, 26 Feb 2013 15:56:45 -0800
Message-Id: <20130226235539.924029307@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit 681d1e8761ca773967bce9bd1bb2896f07279551 upstream.

In the fail1~fail5 failure path, pm_runtime_disable() should
be called to avoid 'Unbalanced pm_runtime_enable' error in
next probe() which may be triggered by defer probe or next
'modprobe musb_hdrc'.

Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1993,6 +1993,7 @@ fail2:
 	musb_platform_exit(musb);
 
 fail1:
+	pm_runtime_disable(musb->controller);
 	dev_err(musb->controller,
 		"musb_init_controller failed with status %d\n", status);
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbbAPXfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 18:35:37 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:49910 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbbAPXde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 18:33:34 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R . Rodriguez" <mcgrof@suse.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 6/8] amd64_edac: enforce synchronous probe
Date: Fri, 16 Jan 2015 15:33:15 -0800
Message-Id: <1421451197-19723-7-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <mcgrof@suse.com>

While testing asynchronous PCI probe on this driver I noticed it failed
so enforce just synchronouse probe for now.  Asynchronous probe is not
used by default and requires userepace intervention.  Patches for its
support will be merged later.

The reason async probe fails is that the init call for this driver
relies on probe to have finished for at least one device. This needs to
be addressed before enabling async probe.

Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/edac/amd64_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 17638d7..58acced 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2983,6 +2983,7 @@ static struct pci_driver amd64_pci_driver = {
 	.probe		= probe_one_instance,
 	.remove		= remove_one_instance,
 	.id_table	= amd64_pci_table,
+	.driver.probe_type = PROBE_FORCE_SYNCHRONOUS,
 };
 
 static void setup_pci_device(void)
-- 
2.2.0.rc0.207.ga3a616c


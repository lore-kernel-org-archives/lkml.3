Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaLEXbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:31:49 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:32933
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaLEXbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:31:46 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        linux-mm@kvack.org, isimatu.yasuaki@jp.fujitsu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] Drivers: base: core: Export functions to lock/unlock device hotplug lock
Date: Fri,  5 Dec 2014 16:41:37 -0800
Message-Id: <1417826498-21172-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1417826471-21131-1-git-send-email-kys@microsoft.com>
References: <1417826471-21131-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hyper-V balloon driver does memory hot-add. The device_hotplug_lock
is designed to address AB BA deadlock issues between the hot-add path
and the sysfs path. Export the APIs to acquire and release the
device_hotplug_lock for use by loadable modules that want to
hot-add memory or CPU.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/base/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 97e2baf..b3073af 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -55,11 +55,13 @@ void lock_device_hotplug(void)
 {
 	mutex_lock(&device_hotplug_lock);
 }
+EXPORT_SYMBOL_GPL(lock_device_hotplug);
 
 void unlock_device_hotplug(void)
 {
 	mutex_unlock(&device_hotplug_lock);
 }
+EXPORT_SYMBOL_GPL(unlock_device_hotplug);
 
 int lock_device_hotplug_sysfs(void)
 {
-- 
1.7.4.1


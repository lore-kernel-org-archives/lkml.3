Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762472AbaGRP0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:26:45 -0400
Received: from isis.lip6.fr ([132.227.60.2]:55112 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762452AbaGRP0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:26:43 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: benoit.taine@lip6.fr, Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/25] rt2x00: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:26:54 +0200
Message-Id: <1405697232-11785-8-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 18 Jul 2014 17:26:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

---
Tested by compilation without errors.

 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 4ccfef5..bdf5590 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1821,7 +1821,7 @@ static const struct rt2x00_ops rt2400pci_ops = {
 /*
  * RT2400pci module information.
  */
-static DEFINE_PCI_DEVICE_TABLE(rt2400pci_device_table) = {
+static const struct pci_device_id rt2400pci_device_table[] = {
 	{ PCI_DEVICE(0x1814, 0x0101) },
 	{ 0, }
 };
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index a511ccc..79f4fe6 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -2120,7 +2120,7 @@ static const struct rt2x00_ops rt2500pci_ops = {
 /*
  * RT2500pci module information.
  */
-static DEFINE_PCI_DEVICE_TABLE(rt2500pci_device_table) = {
+static const struct pci_device_id rt2500pci_device_table[] = {
 	{ PCI_DEVICE(0x1814, 0x0201) },
 	{ 0, }
 };
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index a5b32ca..cc1b3cc 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -400,7 +400,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
 /*
  * RT2800pci module information.
  */
-static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
+static const struct pci_device_id rt2800pci_device_table[] = {
 	{ PCI_DEVICE(0x1814, 0x0601) },
 	{ PCI_DEVICE(0x1814, 0x0681) },
 	{ PCI_DEVICE(0x1814, 0x0701) },
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 9048a9c..8194550 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -3075,7 +3075,7 @@ static const struct rt2x00_ops rt61pci_ops = {
 /*
  * RT61pci module information.
  */
-static DEFINE_PCI_DEVICE_TABLE(rt61pci_device_table) = {
+static const struct pci_device_id rt61pci_device_table[] = {
 	/* RT2561s */
 	{ PCI_DEVICE(0x1814, 0x0301) },
 	/* RT2561 v2 */


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbaJDAW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:22:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbaJCVnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 199/357] ACPI / scan: Correct error return value of create_modalias()
Date: Fri,  3 Oct 2014 14:29:45 -0700
Message-Id: <20141003212939.458702757@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 98d28d0e59160d2d6cb3f6a9050723ac40f89669 upstream.

There is a typo, it should be negative -errno instead.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -128,7 +128,7 @@ static int create_modalias(struct acpi_d
 	list_for_each_entry(id, &acpi_dev->pnp.ids, list) {
 		count = snprintf(&modalias[len], size, "%s:", id->id);
 		if (count < 0)
-			return EINVAL;
+			return -EINVAL;
 		if (count >= size)
 			return -ENOMEM;
 		len += count;



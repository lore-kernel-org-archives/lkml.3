Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaLNUZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:25:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaLNUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:25:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>,
        Alexander Mezin <mezin.alexander@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.17 43/47] Revert: ACPI / EC: Add support to disallow QR_EC to be issued before completing previous QR_EC
Date: Sun, 14 Dec 2014 12:21:18 -0800
Message-Id: <20141214201820.211761533@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 2dbfff81a40b5b2be553042ad5c767e34fdd214c, which
really is commit 558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4 upstream.

Sorry for the confusion, this got applied twice, and reverted once, this
is the second revert and I hope to never touch it again...

Reported-by: Lv Zheng <lv.zheng@intel.com>
Cc: Alexander Mezin <mezin.alexander@gmail.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -299,11 +299,11 @@ static int acpi_ec_transaction_unlocked(
 	/* following two actions should be kept atomic */
 	ec->curr = t;
 	start_transaction(ec);
-	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
-		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
+	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
+		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	ec->curr = NULL;
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;



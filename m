Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbaJCX3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:29:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350AbaJCWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 103/238] ACPI / RTC: Fix CMOS RTC opregion handler accesses to wrong addresses
Date: Fri,  3 Oct 2014 14:30:18 -0700
Message-Id: <20141003212916.971298386@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

commit 9389f46e9782ea5e56fbd7b2e59ba7c08f3ba86b upstream.

The value64 parameter is an u64 point that used to transfer the value
for write to CMOS, or used to return the value that's read from CMOS.

The value64 is an u64 point, so don't need get address again. It causes
acpi_cmos_rtc_space_handler always return 0 to reader and didn't write
expected value to CMOS.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_cmos_rtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/acpi_cmos_rtc.c
+++ b/drivers/acpi/acpi_cmos_rtc.c
@@ -35,7 +35,7 @@ acpi_cmos_rtc_space_handler(u32 function
 		      void *handler_context, void *region_context)
 {
 	int i;
-	u8 *value = (u8 *)&value64;
+	u8 *value = (u8 *)value64;
 
 	if (address > 0xff || !value64)
 		return AE_BAD_PARAMETER;



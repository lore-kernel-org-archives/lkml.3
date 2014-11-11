Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaKKMEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:04:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:23370 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbaKKMET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:04:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="630092098"
Message-ID: <1415707434.22887.158.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 11 Nov 2014 14:03:54 +0200
In-Reply-To: <5461C5AD.5040705@nod.at>
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>
	 <5460F7D8.2030100@nod.at> <5461C5AD.5040705@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 09:15 +0100, Richard Weinberger wrote:
> > Do we really want the function name in every log message?
> > IMHO this is not wise except for pure debug logs.
> 
> BTW: Why UBI-X? This looks odd. Either use UBIX or ubiX.

How about something like this (untested):


From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Tue, 11 Nov 2014 13:56:34 +0200
Subject: [PATCH] UBI: clean-up printing helpers

Let's prefix UBI messages with 'ubiX' instead of 'UBI-X' - this is more
consistent with the way we name UBI devices.

Also, commit "32608703 UBI: Extend UBI layer debug/messaging capabilities"
added the function name print to 'ubi_msg()' - lets revert this change, since
these messages are supposed to be just informative messages, and not debugging
messages.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/ubi/ubi.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index f80ffab..7a92283 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -50,13 +50,13 @@
 #define UBI_NAME_STR "ubi"
 
 /* Normal UBI messages */
-#define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
-					 ubi->ubi_num, __func__, ##__VA_ARGS__)
+#define ubi_msg(ubi, fmt, ...) pr_notice("ubi%d: " fmt "\n", \
+					 ubi->ubi_num, ##__VA_ARGS__)
 /* UBI warning messages */
-#define ubi_warn(ubi, fmt, ...) pr_warn("UBI-%d warning: %s: " fmt "\n", \
+#define ubi_warn(ubi, fmt, ...) pr_warn("ubi%d warning: %s: " fmt "\n", \
 					ubi->ubi_num, __func__, ##__VA_ARGS__)
 /* UBI error messages */
-#define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n", \
+#define ubi_err(ubi, fmt, ...) pr_err("ubi%d error: %s: " fmt "\n", \
 				      ubi->ubi_num, __func__, ##__VA_ARGS__)
 
 /* Background thread name pattern */
-- 
1.9.3




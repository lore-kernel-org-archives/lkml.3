Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965260AbaDJDX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935109AbaDJDW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 115/134] hwmon: (coretemp) Add support for Atom CE4110/4150/4170
Date: Wed,  9 Apr 2014 20:23:51 -0700
Message-Id: <20140410032314.069819024@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 1102dcab849313bd5a340b299b5cf61b518fbc0f upstream.

TjMax for the CE4100 series of Atom CPUs was previously reported to be
110 degrees C.

cpuinfo logs on the web show existing CPU types CE4110, CE4150, and CE4170,
reported as "model name : Intel(R) Atom(TM) CPU CE41{1|5|7}0 @ 1.{2|6}0GHz"
with model 28 (0x1c) and stepping 10 (0x0a). Add the three known variants
to the tjmax table.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/hwmon/coretemp |    1 +
 drivers/hwmon/coretemp.c     |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -94,6 +94,7 @@ Process		Processor					TjMax(C)
 		330/230						125
 		E680/660/640/620				90
 		E680T/660T/640T/620T				110
+		CE4170/4150/4110				110
 
 45nm		Core2 Processors
 		Solo ULV SU3500/3300				100
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -205,8 +205,11 @@ static struct tjmax __cpuinitconst tjmax
 	{ "CPU N455", 100000 },
 	{ "CPU N470", 100000 },
 	{ "CPU N475", 100000 },
-	{ "CPU  230", 100000 },
-	{ "CPU  330", 125000 },
+	{ "CPU  230", 100000 },		/* Model 0x1c, stepping 2	*/
+	{ "CPU  330", 125000 },		/* Model 0x1c, stepping 2	*/
+	{ "CPU CE4110", 110000 },	/* Model 0x1c, stepping 10	*/
+	{ "CPU CE4150", 110000 },	/* Model 0x1c, stepping 10	*/
+	{ "CPU CE4170", 110000 },	/* Model 0x1c, stepping 10	*/
 };
 
 static int __cpuinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id,



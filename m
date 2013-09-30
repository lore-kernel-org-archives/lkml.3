Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3I3P37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:29:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21569 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab3I3P34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:29:56 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-50-524998f25624
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] x86/acpi: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 17:29:43 +0200
Message-id: <1834728.TOn9scBO35@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd1PMzyDDJ6+Nrc42/SG3WLWlL1M
	Fpd3zWGz+Nx7hNHi7qmjbBb9C3uZLCb8vsDmwO6xeM9LJo/Zd38wevRtWcXo8WhxC6PHitXf
	2T0+b5ILYIvisklJzcksSy3St0vgynj++Q57wWz2igMdt9gaGPvZuhg5OSQETCRO/vjPCmGL
	SVy4tx4sLiQwnVHi1lflLkYuILuFSaJx+SJGkASbgJXExPZVYLaIgJbE5qaXzCBFzAKnGCWW
	3L4C1i0s4C7R9HQZE4jNIqAqcXTCXrAGXgFNiftzrjOD2KICnhKfJi1lhogLSvyYfI8FxGYW
	kJfYt38qK4StJbF+53GmCYx8s5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5
	uZsYwQH8THoH46oGi0OMAhyMSjy8BvWeQUKsiWXFlbmHGCU4mJVEeF9PAArxpiRWVqUW5ccX
	leakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgXNzTsPmZZojU5bvJtw5rq7wy
	izyjL57C1sv+v/Jt65s98671mFkam6dqb7j+53h2wIqTxbUe1btS/I0Pfm9wbZmdW/y32vnT
	tLJ+O/GFugUSyztsZFvkZ10/MKmDNaeOiX2Fhmlb08cSa4vy1y3PX3TNS13IxlHSweB4P13m
	K/usvAKzXdVKLMUZiYZazEXFiQBkyPQkXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should not be placed between "struct" and "resource"
because it prevents the variable from being placed in the intended
.init.data section. Fix it.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
- fixed patch description

 arch/x86/kernel/acpi/boot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 1f7c074..6c0b43b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -695,7 +695,7 @@ static int __init acpi_parse_sbf(struct acpi_table_header *table)
 #ifdef CONFIG_HPET_TIMER
 #include <asm/hpet.h>
 
-static struct __initdata resource *hpet_res;
+static struct resource *hpet_res __initdata;
 
 static int __init acpi_parse_hpet(struct acpi_table_header *table)
 {
-- 
1.8.2.3



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbaIKMlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:41:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51670 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Binderman" <dcb314@hotmail.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Andrey Utkin" <andrey.krieger.utkin@gmail.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.375535928@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 052/131] powerpc/mm/numa: Fix break placement
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>

commit b00fc6ec1f24f9d7af9b8988b6a198186eb3408c upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81631
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -600,8 +600,8 @@ static int __cpuinit cpu_numa_callback(s
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		unmap_cpu_from_node(lcpu);
-		break;
 		ret = NOTIFY_OK;
+		break;
 #endif
 	}
 	return ret;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaDWNaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:30:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8259 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbaDWN3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:49 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-58-5357c04c43e9
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 06/20] ima: create '_ima' as a builtin 'trusted' keyring
Date: Wed, 23 Apr 2014 16:30:24 +0300
Message-id: <28b0bcd6e331cb81432089a9a3edce5c8e517566.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xq7o+B8KDDR5/k7C49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mo4/ekWa8Ffrop/3VtZGhgnc3YxcnJICJhIzDp5lhXCFpO4
	cG89WxcjF4eQwFJGiW0PprNCOJ1MEtuvnmMEqWIT0JPY0PyDHcQWEXCR2D2njwmkiFmgh1Fi
	95/FzCAJYQEPiUuzT4DZLAKqEjs//WACsXkF4iQWXdrIDrFOQWLZl7VgNZwCVhJ/mqeDxYUE
	LCW+T5qMU3wCI/8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHh+GUH4+JjVocYBTgY
	lXh4JZaHBQuxJpYVV+YeYpTgYFYS4V2yKDxYiDclsbIqtSg/vqg0J7X4ECMTB6dUA6PGKZVZ
	1jdelt0qN301W417ZVQ5s4VqbqVJrvL0d7tfu7VL2B7/erpmmtS7qjX/Lfu+WRhJyj14K/Gf
	Syb58pHjFW3WkX9e7r+qe91HQVlAtzXTZWnE1hZmTs9sx85SXbOMuX2y1UzX5lQozdNxcC/q
	vetjxDv3x4ngpoLviz6uD1g/abm8jhJLcUaioRZzUXEiAJWS5folAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Require all keys added to the IMA keyring be signed by an
existing trusted key on the system trusted keyring.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/Kconfig    | 9 +++++++++
 security/integrity/ima/ima_init.c | 1 +
 2 files changed, 10 insertions(+)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 5f95e50..be11c01 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -122,3 +122,12 @@ config IMA_APPRAISE
 	  For more information on integrity appraisal refer to:
 	  <http://linux-ima.sourceforge.net>
 	  If unsure, say N.
+
+config IMA_TRUSTED_KEYRING
+	bool "Require all keys on the _ima keyring be signed"
+	depends on IMA && SYSTEM_TRUSTED_KEYRING
+	select INTEGRITY_TRUSTED_KEYRING
+	default y
+	help
+	   This option requires that all keys added to the _ima
+	   keyring be signed by a key on the system trusted keyring.
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index e8f9d70..515c1a2 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -107,6 +107,7 @@ int __init ima_init(void)
 
 	ima_add_boot_aggregate();	/* boot aggregate must be first entry */
 	ima_init_policy();
+	integrity_init_keyring(INTEGRITY_KEYRING_IMA);
 
 	return ima_fs_init();
 }
-- 
1.8.3.2


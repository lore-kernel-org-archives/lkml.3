Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaBMDUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:20:00 -0500
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:52551
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbaBMDTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:19:19 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: lenb@kernel.org, rjw@rjwysocki.net, rui.zhang@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH 5/6] drivers/acpi: fix sbs driver compile error when CONFIG_PM_SLEEP is undefined
Date: Wed, 12 Feb 2014 20:19:09 -0700
Message-Id: <9b235e287cc48364565278baeee69accc96264e7.1392250669.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1392250669.git.shuah.kh@samsung.com>
References: <cover.1392250669.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1392250669.git.shuah.kh@samsung.com>
References: <cover.1392250669.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sbs driver defines acpi_sbs_resume() when CONFIG_PM_SLEEP is defined. This
results in the following compile error when CONFIG_PM_SLEEP is undefined.

  CC [M]  drivers/acpi/sbs.o
drivers/acpi/sbs.c:674:8: error: ‘acpi_sbs_resume’ undeclared here (not in a function)

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/acpi/sbs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index d465ae6..48c92c6 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -668,6 +668,8 @@ static int acpi_sbs_resume(struct device *dev)
 	acpi_sbs_callback(sbs);
 	return 0;
 }
+#else
+#define acpi_sbs_resume NULL
 #endif
 
 static SIMPLE_DEV_PM_OPS(acpi_sbs_pm, NULL, acpi_sbs_resume);
-- 
1.7.10.4


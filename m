Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3I2UeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:34:22 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:44347 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3I2Udy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:33:54 -0400
Message-ID: <52488D5A.6010504@ladisch.de>
Date: Sun, 29 Sep 2013 22:28:10 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tomas Winkler <tomas.winkler@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] hpet: remove useless check if fixmem32 is NULL
References: <1378298152-30765-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1378298152-30765-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

fixmem32 is assigned to address of res->data member
so the address is always valid

Actually since we are not checking for res != NULL
static analyzing is complaining about referencing the pointer
and consequent check for null.
The code snippet looks confusing also for human eyes.

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/char/hpet.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index ab8651d..d6568a6 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -971,8 +971,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		struct acpi_resource_fixed_memory32 *fixmem32;

 		fixmem32 = &res->data.fixed_memory32;
-		if (!fixmem32)
-			return AE_NO_MEMORY;

 		hdp->hd_phys_address = fixmem32->address;
 		hdp->hd_address = ioremap(fixmem32->address,

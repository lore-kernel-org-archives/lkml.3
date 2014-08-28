Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936196AbaH1CUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:20:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:27428 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284AbaH1CUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:20:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,415,1406617200"; 
   d="scan'208";a="582676534"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch v4 02/16] ACPI: Correct return value of acpi_dev_resource_address_space()
Date: Thu, 28 Aug 2014 10:22:27 +0800
Message-Id: <1409192561-19744-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change acpi_dev_resource_address_space() to return failure if the
acpi_resource structure can't be converted to an ACPI address64
structure, so caller could correctly detect failure.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 2ba8f02ced36..782a0d15c25f 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -200,7 +200,7 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
 
 	status = acpi_resource_to_address64(ares, &addr);
 	if (ACPI_FAILURE(status))
-		return true;
+		return false;
 
 	res->start = addr.minimum;
 	res->end = addr.maximum;
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab3CSRH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:07:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab3CSRH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:07:56 -0400
Date: Tue, 19 Mar 2013 13:07:48 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        kexec@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH v2] acpi: Ignore acpi_rsdp kernel parameter in a secure boot
 environment
Message-ID: <20130319170747.GA15821@hansolo.jdub.homelinux.org>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
 <1363642353-30749-10-git-send-email-matthew.garrett@nebula.com>
 <5148261F.3030806@redhat.com>
 <20130319111916.GI11243@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319111916.GI11243@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option allows userspace to pass the RSDP address to the kernel.  This
could potentially be used to circumvent the secure boot trust model.
This is setup through the setup_arch function, which is called before the
security_init function sets up the security_ops, so we cannot use a
capable call here.  We ignore the setting if we are booted in Secure Boot
mode.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---

 v2: Actually send it to Matthew this time

 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 586e7e9..8950454 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -245,7 +245,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
 #ifdef CONFIG_KEXEC
-	if (acpi_rsdp)
+	if (acpi_rsdp && !efi_enabled(EFI_SECURE_BOOT))
 		return acpi_rsdp;
 #endif
 
-- 
1.8.1.2


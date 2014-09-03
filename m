Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaICWRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:17:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbaICWQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Semen Protsenko <semen.protsenko@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 3.16 032/125] efi/arm64: Store Runtime Services revision
Date: Wed,  3 Sep 2014 15:06:29 -0700
Message-Id: <20140903220624.624226734@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Semen Protsenko <semen.protsenko@linaro.org>

commit 6a7519e81321343165f89abb8b616df186d3e57a upstream.

"efi" global data structure contains "runtime_version" field which must
be assigned in order to use it later in Runtime Services virtual calls
(virt_efi_* functions).

Before this patch "runtime_version" was unassigned (0), so each
Runtime Service virtual call that checks revision would fail.

Signed-off-by: Semen Protsenko <semen.protsenko@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/efi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -464,6 +464,8 @@ static int __init arm64_enter_virtual_mo
 
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
+	efi.runtime_version = efi.systab->hdr.revision;
+
 	return 0;
 }
 early_initcall(arm64_enter_virtual_mode);



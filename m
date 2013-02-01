Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422897Ab3BAKwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:52:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:39569 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422863Ab3BAKv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:51:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [ 31/33] x86, efi: Set runtime_version to the EFI spec revision
Date: Fri,  1 Feb 2013 11:49:36 +0100
Message-Id: <20130201104726.860881075@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit 712ba9e9afc4b3d3d6fa81565ca36fe518915c01 upstream.

efi.runtime_version is erroneously being set to the value of the
vendor's firmware revision instead of that of the implemented EFI
specification. We can't deduce which EFI functions are available based
on the revision of the vendor's firmware since the version scheme is
likely to be unique to each vendor.

What we really need to know is the revision of the implemented EFI
specification, which is available in the EFI System Table header.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -900,7 +900,7 @@ void __init efi_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
-	efi.runtime_version = efi_systab.fw_revision;
+	efi.runtime_version = efi_systab.hdr.revision;
 	efi.get_time = virt_efi_get_time;
 	efi.set_time = virt_efi_set_time;
 	efi.get_wakeup_time = virt_efi_get_wakeup_time;



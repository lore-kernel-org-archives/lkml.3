Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730Ab3CLWkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:40:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab3CLWdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>,
        Corentin Chary <corentincj@iksaif.net>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [ 082/100] acer-wmi: avoid the warning of devices may be used uninitialized
Date: Tue, 12 Mar 2013 15:32:07 -0700
Message-Id: <20130312223131.758571232@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>

commit f24c96eae58aeea4c36fb064cf3ee9734933f8fc upstream.

Fengguang Wu run kernel build test to platform-drivers-x86/linux-next git tree
on x86_64 architecture and found a warning that was introduced by
727651bf738b6b917335025d09323d0962eda114 commit:

drivers/platform/x86/acer-wmi.c: In function âWMID_set_capabilitiesâ:
drivers/platform/x86/acer-wmi.c:1211: warning: âdevicesâ may be used
uninitialized in this function

This patch fixes the above warning message.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/acer-wmi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1204,6 +1204,9 @@ static acpi_status WMID_set_capabilities
 			devices = *((u32 *) obj->buffer.pointer);
 		} else if (obj->type == ACPI_TYPE_INTEGER) {
 			devices = (u32) obj->integer.value;
+		} else {
+			kfree(out.pointer);
+			return AE_ERROR;
 		}
 	} else {
 		kfree(out.pointer);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3CLWc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:32:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3CLWcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mattia Dongili <malattia@linux.it>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [ 012/100] sony-laptop: fully enable SNY controlled modems
Date: Tue, 12 Mar 2013 15:30:57 -0700
Message-Id: <20130312223124.275058554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mattia Dongili <malattia@linux.it>

commit 3ec1c3983d73b1e3d4cfd72afab94c34eceafe8a upstream.

The call to handlers 0x124 and 0x135 (rfkill control) seems to take a
bitmask to control various states of the device. For our rfkill we need
a fully on/off. SVZ1311Z9R/X's LTE modem needs more bits up.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47751
Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/sony-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1534,7 +1534,7 @@ static int sony_nc_rfkill_set(void *data
 	int argument = sony_rfkill_address[(long) data] + 0x100;
 
 	if (!blocked)
-		argument |= 0x030000;
+		argument |= 0x070000;
 
 	return sony_call_snc_handle(sony_rfkill_handle, argument, &result);
 }



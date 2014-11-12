Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbaKLB3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:29:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbaKLB26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Salter <msalter@redhat.com>, Dave Young <dyoung@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 3.17 177/319] rtc: Disable EFI rtc for x86
Date: Wed, 12 Nov 2014 10:15:15 +0900
Message-Id: <20141112011021.992179503@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit 7efe665903d0d963b0ebf4cab25cc3ae32c62600 upstream.

commit da167ad7638759 ("rtc: ia64: allow other architectures to use EFI
RTC") inadvertently introduced a regression for x86 because we've been
careful not to enable the EFI rtc driver due to the generally buggy
implementations of the time-related EFI runtime services.

In fact, since the above commit was merged we've seen reports of crashes
on 32-bit tablets,

  https://bugzilla.kernel.org/show_bug.cgi?id=84241#c21

Disable it explicitly for x86 so that we don't give users false hope
that this driver will work - it won't, and your machine is likely to
crash.

Acked-by: Mark Salter <msalter@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -806,7 +806,7 @@ config RTC_DRV_DA9063
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on EFI
+	depends on EFI && !X86
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbaF1Sma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:42:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbaF1RuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Binderman <dcb314@hotmail.com>,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 058/110] ACPICA: utstring: Check array index bound before use.
Date: Sat, 28 Jun 2014 10:46:55 -0700
Message-Id: <20140628174549.057834787@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Binderman <dcb314@hotmail.com>

commit 5d42b0fa25df7ef2f575107597c1aaebe2407d10 upstream.

ACPICA BZ 1077. David Binderman.

References: https://bugs.acpica.org/show_bug.cgi?id=1077
Signed-off-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/utstring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/acpica/utstring.c
+++ b/drivers/acpi/acpica/utstring.c
@@ -353,7 +353,7 @@ void acpi_ut_print_string(char *string,
 	}
 
 	acpi_os_printf("\"");
-	for (i = 0; string[i] && (i < max_length); i++) {
+	for (i = 0; (i < max_length) && string[i]; i++) {
 
 		/* Escape sequences */
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbaJULuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:50:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaJULt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:49:57 -0400
Message-ID: <5446485D.7000708@redhat.com>
Date: Tue, 21 Oct 2014 13:49:49 +0200
From: =?windows-1252?Q?Matej_Mu=9Eila?= <mmuzila@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: kys@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tools: hv: fcopy_daemon: Don't use uninitialized variable
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matej Mužila <mmuzila@redhat.com>

Don't use uninitialized variable

Signed-off-by: Matej Mužila <mmuzila@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
---
diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index 1fc2dc2..0f8f918 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -191,7 +191,7 @@ int main(void)
 		default:
 			syslog(LOG_ERR, "Unknown operation: %d",
 				in_msg->operation);
-
+			error = HV_ERROR_NOT_SUPPORTED;
 		}
 
 		if (pwrite(fcopy_fd, &error, sizeof(int), 0) != sizeof(int)) {


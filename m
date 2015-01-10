Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbbAJFHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:07:44 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:41343
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbbAJFGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:06:49 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 4/5] Tools: hv: address compiler warnings for hv_fcopy_daemon.c
Date: Fri,  9 Jan 2015 22:18:54 -0800
Message-Id: <1420870735-2265-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1420870735-2265-1-git-send-email-kys@microsoft.com>
References: <1420870690-2223-1-git-send-email-kys@microsoft.com>
 <1420870735-2265-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

This patch addresses two types of compiler warnings:
... warning: unused variable .fd. [-Wunused-variable]
and
... warning: format .%s. expects argument of type .char *., but argument 5 has type .__u16 *. [-Wformat=]

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_fcopy_daemon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index f437d73..1a23872 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -51,7 +51,7 @@ static int hv_start_fcopy(struct hv_start_fcopy *smsg)
 
 	p = (char *)smsg->path_name;
 	snprintf(target_fname, sizeof(target_fname), "%s/%s",
-		(char *)smsg->path_name, smsg->file_name);
+		 (char *)smsg->path_name, (char *)smsg->file_name);
 
 	syslog(LOG_INFO, "Target file name: %s", target_fname);
 	/*
@@ -137,7 +137,7 @@ void print_usage(char *argv[])
 
 int main(int argc, char *argv[])
 {
-	int fd, fcopy_fd, len;
+	int fcopy_fd, len;
 	int error;
 	int daemonize = 1, long_index = 0, opt;
 	int version = FCOPY_CURRENT_VERSION;
-- 
1.7.4.1


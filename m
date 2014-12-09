Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaLIQO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:14:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaLIQO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:14:27 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 4/5] Tools: hv: address compiler warnings for hv_fcopy_daemon.c
Date: Tue,  9 Dec 2014 16:48:22 +0100
Message-Id: <1418140103-11854-5-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses two types of compiler warnings:
... warning: unused variable ‘fd’ [-Wunused-variable]
and
... warning: format ‘%s’ expects argument of type ‘char *’, but argument 5 has type ‘__u16 *’ [-Wformat=]

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/hv_fcopy_daemon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
1.9.3


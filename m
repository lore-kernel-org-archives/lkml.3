Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3DXGUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:20:14 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49641 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3DXGUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:20:11 -0400
Subject: [PATCH v2 1/8] powerpc/pseries: Remove syslog prefix in
 uncompressed oops text
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Wed, 24 Apr 2013 11:50:03 +0530
Message-ID: <20130424062003.7341.96872.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130424061807.7341.909.stgit@aruna-ThinkPad-T420>
References: <20130424061807.7341.909.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042406-2000-0000-0000-00000BD92E90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of syslog prefix in the uncompressed oops text will
help in capturing more oops data.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 8733a86..e54a8b7 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -619,7 +619,7 @@ static void oops_to_nvram(struct kmsg_dumper *dumper,
 	}
 	if (rc != 0) {
 		kmsg_dump_rewind(dumper);
-		kmsg_dump_get_buffer(dumper, true,
+		kmsg_dump_get_buffer(dumper, false,
 				     oops_data, oops_data_sz, &text_len);
 		err_type = ERR_TYPE_KERNEL_PANIC;
 		*oops_len = (u16) text_len;


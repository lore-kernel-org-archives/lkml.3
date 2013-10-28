Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab3J1Otb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:49:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51187 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3J1Ot0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chen Gang <gang.chen@asianux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 31/64] powerpc/pseries/lparcfg: Fix possible overflow are more than 1026
Date: Mon, 28 Oct 2013 14:47:50 +0000
Message-Id: <1382971703-17393-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit 5676005acf26ab7e924a8438ea4746e47d405762 upstream.

need set '\0' for 'local_buffer'.

SPLPAR_MAXLENGTH is 1026, RTAS_DATA_BUF_SIZE is 4096. so the contents of
rtas_data_buf may truncated in memcpy.

if contents are really truncated.
  the splpar_strlen is more than 1026. the next while loop checking will
  not find the end of buffer. that will cause memory access violation.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/lparcfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 7ebbae0..f62fda1 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -307,6 +307,7 @@ static void parse_system_parameter_string(struct seq_file *m)
 				__pa(rtas_data_buf),
 				RTAS_DATA_BUF_SIZE);
 	memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
+	local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
 	spin_unlock(&rtas_data_buf_lock);
 
 	if (call_status != 0) {
-- 
1.8.3.2


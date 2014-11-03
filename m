Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKCMwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:52:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaKCMwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:52:03 -0500
Date: Mon, 3 Nov 2014 04:51:52 -0800
From: tip-bot for James Custer <tipbot@zytor.com>
Message-ID: <tip-3ab0c49fd6b1e80438d0a649584d292880112262@git.kernel.org>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@kernel.org, jcuster@sgi.com,
        linux-kernel@vger.kernel.org, rja@sgi.com
Reply-To: rja@sgi.com, linux-kernel@vger.kernel.org, jcuster@sgi.com,
        mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <1414952199-185319-1-git-send-email-jcuster@sgi.com>
References: <1414952199-185319-1-git-send-email-jcuster@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86: UV BAU: Increase maximum CPUs per socket/hub
Git-Commit-ID: 3ab0c49fd6b1e80438d0a649584d292880112262
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ab0c49fd6b1e80438d0a649584d292880112262
Gitweb:     http://git.kernel.org/tip/3ab0c49fd6b1e80438d0a649584d292880112262
Author:     James Custer <jcuster@sgi.com>
AuthorDate: Sun, 2 Nov 2014 12:16:38 -0600
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 13:49:24 +0100

x86: UV BAU: Increase maximum CPUs per socket/hub

We have encountered hardware with 18 cores/socket that gives 36 CPUs/socket
with hyperthreading enabled. This exceeds the current MAX_CPUS_PER_SOCKET
causing a failure in get_cpu_topology. Increase MAX_CPUS_PER_SOCKET to 64
and MAX_CPUS_PER_UVHUB to 128.

Signed-off-by: James Custer <jcuster@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Link: http://lkml.kernel.org/r/1414952199-185319-1-git-send-email-jcuster@sgi.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/uv/uv_bau.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 2d60a78..fc808b8 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -33,8 +33,8 @@
  * Each of the descriptors is 64 bytes in size (8*64 = 512 bytes in a set).
  */
 
-#define MAX_CPUS_PER_UVHUB		64
-#define MAX_CPUS_PER_SOCKET		32
+#define MAX_CPUS_PER_UVHUB		128
+#define MAX_CPUS_PER_SOCKET		64
 #define ADP_SZ				64 /* hardware-provided max. */
 #define UV_CPUS_PER_AS			32 /* hardware-provided max. */
 #define ITEMS_PER_DESC			8

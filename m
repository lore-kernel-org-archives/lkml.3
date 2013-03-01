Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3CATpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3CATpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        PaX Team <pageexec@freemail.hu>,
        Mathias Krause <minipli@googlemail.com>,
        David Rientjes <rientjes@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 22/77] x86/apic: Fix parsing of the lapic cmdline option
Date: Fri,  1 Mar 2013 11:44:07 -0800
Message-Id: <20130301194354.354775176@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 27cf929845b10043f2257693c7d179a9e0b1980e upstream.

Including " lapic " in the kernel cmdline on an x86-64 kernel
makes it panic while parsing early params -- e.g. with no user
visible output.

Fix this bug by ensuring arg is non-NULL before passing it to
strncmp().

Reported-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1361303227-13174-1-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -131,7 +131,7 @@ static int __init parse_lapic(char *arg)
 {
 	if (config_enabled(CONFIG_X86_32) && !arg)
 		force_enable_local_apic = 1;
-	else if (!strncmp(arg, "notscdeadline", 13))
+	else if (arg && !strncmp(arg, "notscdeadline", 13))
 		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 	return 0;
 }



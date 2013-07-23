Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557Ab3GWW1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934426Ab3GWW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 019/103] powerpc/perf: Use existing out label in power_pmu_enable()
Date: Tue, 23 Jul 2013 15:25:30 -0700
Message-Id: <20130723220420.695626908@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit 0a48843d6c5114cfa4a9540ee4d6af87628cec01 upstream.

In power_pmu_enable() we can use the existing out label to reduce the
number of return paths.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/core-book3s.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -919,12 +919,13 @@ static void power_pmu_enable(struct pmu
 
 	if (!ppmu)
 		return;
+
 	local_irq_save(flags);
+
 	cpuhw = &__get_cpu_var(cpu_hw_events);
-	if (!cpuhw->disabled) {
-		local_irq_restore(flags);
-		return;
-	}
+	if (!cpuhw->disabled)
+		goto out;
+
 	cpuhw->disabled = 0;
 
 	/*



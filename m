Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbbA1CB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:01:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760117AbbA1BiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 23/77] x86, hyperv: Mark the Hyper-V clocksource as being continuous
Date: Tue, 27 Jan 2015 17:27:01 -0800
Message-Id: <20150128012746.654616235@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 32c6590d126836a062b3140ed52d898507987017 upstream.

The Hyper-V clocksource is continuous; mark it accordingly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Acked-by: jasowang@redhat.com
Cc: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org
Cc: olaf@aepfle.de
Cc: apw@canonical.com
Link: http://lkml.kernel.org/r/1421108762-3331-1-git-send-email-kys@microsoft.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mshyperv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -67,6 +67,7 @@ static struct clocksource hyperv_cs = {
 	.rating		= 400, /* use this when running on Hyperv*/
 	.read		= read_hv_clock,
 	.mask		= CLOCKSOURCE_MASK(64),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init ms_hyperv_init_platform(void)



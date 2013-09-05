Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3IEUg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:36:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab3IEU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 34/36] xen/arm: missing put_cpu in xen_percpu_init
Date: Thu,  5 Sep 2013 13:28:03 -0700
Message-Id: <20130905202706.272629469@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Grall <julien.grall@linaro.org>

commit 0d7febe58413884f6428143221971618fbf3a47d upstream.

When CONFIG_PREEMPT is enabled, Linux will not be able to boot and warn:
[    4.127825] ------------[ cut here ]------------
[    4.133376] WARNING: at init/main.c:699 do_one_initcall+0x150/0x158()
[    4.140738] initcall xen_init_events+0x0/0x10c returned with preemption imbalance

This is because xen_percpu_init uses get_cpu but doesn't have the corresponding
put_cpu.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/xen/enlighten.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -170,6 +170,7 @@ static void __init xen_percpu_init(void
 	per_cpu(xen_vcpu, cpu) = vcpup;
 
 	enable_percpu_irq(xen_events_irq, 0);
+	put_cpu();
 }
 
 static void xen_restart(char str, const char *cmd)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3EIW0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:26:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3EIW0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <ian.camjpbell@citrix.com>
Subject: [ 01/73] xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq
Date: Thu,  9 May 2013 15:24:51 -0700
Message-Id: <20130509222526.626740190@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 2798ba7d19aed645663398a21ec4006bfdbb1ef3 upstream.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Ian Campbell <ian.camjpbell@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/xen/enlighten.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -239,7 +239,7 @@ static int __init xen_init_events(void)
 	xen_init_IRQ();
 
 	if (request_percpu_irq(xen_events_irq, xen_arm_callback,
-			"events", xen_vcpu)) {
+			"events", &xen_vcpu)) {
 		pr_err("Error requesting IRQ %d\n", xen_events_irq);
 		return -EINVAL;
 	}



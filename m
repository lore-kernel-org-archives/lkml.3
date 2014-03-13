Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaCMP6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:58:31 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65451 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaCMP6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:58:07 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu
Cc: tech@virtualopensystems.com, n.nikolaev@virtualopensystems.com,
        agraf@suse.de, christoffer.dall@linaro.org, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MA...),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 4/4] ARM: KVM: enable KVM_CAP_IOEVENTFD
Date: Thu, 13 Mar 2014 16:57:29 +0100
Message-Id: <1394726249-1547-5-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394726249-1547-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1394726249-1547-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM on ARM can now advertise support for the ioeventfd capability.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
---
 arch/arm/kvm/arm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index bd18bb8..08cd89b 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -211,6 +211,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_IOEVENTFD:
+		r = 1;
+		break;
 	default:
 		r = kvm_arch_dev_ioctl_check_extension(ext);
 		break;
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3INMLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab3INMLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:11:46 -0400
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: catalin.marinas@arm.com, christoffer.dall@linaro.org, gleb@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, pbonzini@redhat.com, linux@arm.linux.org.uk,
        will.deacon@arm.com
Subject: [PATCH 1/3] arm: kvm: clamp NR_VCPUS to MAX_VCPUS
Date: Sat, 14 Sep 2013 14:10:54 +0200
Message-Id: <1379160656-28050-2-git-send-email-drjones@redhat.com>
In-Reply-To: <1379160656-28050-1-git-send-email-drjones@redhat.com>
References: <1379160656-28050-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 741f66a2edbd7..9ebf8ac3a12ff 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -201,7 +201,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		r = min(num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-- 
1.8.1.4


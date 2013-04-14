Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941Ab3DNFzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 01:55:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45605 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750737Ab3DNFzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 01:55:46 -0400
Message-ID: <1365918945.1878.8.camel@joe-AO722>
Subject: [PATCH] ARM: KVM: Add missing break;
From: Joe Perches <joe@perches.com>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Date: Sat, 13 Apr 2013 22:55:45 -0700
In-Reply-To: <1365917315-3615-1-git-send-email-linux@prisktech.co.nz>
References: <1365917315-3615-1-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3401d54696f ("KVM: ARM: Introduce KVM_ARM_SET_DEVICE_ADDR ioctl")
added the case, but omitted adding break;

Add it.

Found with grep version 2.54 pattern:

$ grep -rP --include=*.[ch] "\b(\w+)\s*=[^;]+;\s*(?:case\s+\w+:|default:)\s*\1\s*="

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 5777e0c..b9f2228 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -198,6 +198,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
 		r = 1;
+		break;
 	case KVM_CAP_NR_VCPUS:
 		r = num_online_cpus();
 		break;



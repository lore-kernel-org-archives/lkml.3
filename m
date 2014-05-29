Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbaE2FnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:43:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbaE2Een (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.14 004/140] KVM: x86: remove WARN_ON from get_kernel_ns()
Date: Wed, 28 May 2014 21:32:23 -0700
Message-Id: <20140529043050.131071360@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit b351c39cc9e0151cee9b8d52a1e714928faabb38 upstream.

Function and callers can be preempted.

https://bugzilla.kernel.org/show_bug.cgi?id=73721

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1109,7 +1109,6 @@ static inline u64 get_kernel_ns(void)
 {
 	struct timespec ts;
 
-	WARN_ON(preemptible());
 	ktime_get_ts(&ts);
 	monotonic_to_bootbased(&ts);
 	return timespec_to_ns(&ts);



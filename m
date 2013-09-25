Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3IYArH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:47:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3IYAUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>
Subject: [ 024/117] KVM: PPC: Book3S: Fix compile error in XICS emulation
Date: Tue, 24 Sep 2013 17:18:10 -0700
Message-Id: <20130925001743.480503316@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit 7bfa9ad55d691f2b836b576769b11eca2cf50816 upstream.

Commit 8e44ddc3f3 ("powerpc/kvm/book3s: Add support for H_IPOLL and
H_XIRR_X in XICS emulation") added a call to get_tb() but didn't
include the header that defines it, and on some configs this means
book3s_xics.c fails to compile:

arch/powerpc/kvm/book3s_xics.c: In function ‘kvmppc_xics_hcall’:
arch/powerpc/kvm/book3s_xics.c:812:3: error: implicit declaration of function ‘get_tb’ [-Werror=implicit-function-declaration]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_xics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -19,6 +19,7 @@
 #include <asm/hvcall.h>
 #include <asm/xics.h>
 #include <asm/debug.h>
+#include <asm/time.h>
 
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>



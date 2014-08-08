Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbaHHWAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:00:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933108AbaHHVgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 17/39] sparc64: Fix argument sign extension for compat_sys_futex().
Date: Fri,  8 Aug 2014 14:35:03 -0700
Message-Id: <20140808213355.721808895@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit aa3449ee9c87d9b7660dd1493248abcc57769e31 ]

Only the second argument, 'op', is signed.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/sys32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/sys32.S
+++ b/arch/sparc/kernel/sys32.S
@@ -44,7 +44,7 @@ SIGN1(sys32_timer_settime, compat_sys_ti
 SIGN1(sys32_io_submit, compat_sys_io_submit, %o1)
 SIGN1(sys32_mq_open, compat_sys_mq_open, %o1)
 SIGN1(sys32_select, compat_sys_select, %o0)
-SIGN3(sys32_futex, compat_sys_futex, %o1, %o2, %o5)
+SIGN1(sys32_futex, compat_sys_futex, %o1)
 SIGN1(sys32_recvfrom, compat_sys_recvfrom, %o0)
 SIGN1(sys32_recvmsg, compat_sys_recvmsg, %o0)
 SIGN1(sys32_sendmsg, compat_sys_sendmsg, %o0)



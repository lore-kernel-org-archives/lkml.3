Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbbAYSMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:12:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbbAYSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Daniel Walter <d.walter@0x90.at>
Subject: [PATCH 3.18 176/183] um: Skip futex_atomic_cmpxchg_inatomic() test
Date: Sun, 25 Jan 2015 10:08:18 -0800
Message-Id: <20150125180817.810522003@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit f911d731054ab3d82ee72a16b889e17ca3a2332a upstream.

futex_atomic_cmpxchg_inatomic() does not work on UML because
it triggers a copy_from_user() in kernel context.
On UML copy_from_user() can only be used if the kernel was called
by a real user space process such that UML can use ptrace()
to fetch the value.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Tested-by: Daniel Walter <d.walter@0x90.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/Kconfig.common |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -3,6 +3,7 @@ config UML
 	default y
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_UID16
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO



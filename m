Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbbAYTLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:11:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbbAYSJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Daniel Walter <d.walter@0x90.at>
Subject: [PATCH 3.14 79/98] um: Skip futex_atomic_cmpxchg_inatomic() test
Date: Sun, 25 Jan 2015 10:07:37 -0800
Message-Id: <20150125180716.298410117@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2,6 +2,7 @@ config UML
 	bool
 	default y
 	select HAVE_UID16
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO



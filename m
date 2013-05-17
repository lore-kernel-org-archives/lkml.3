Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3EQVov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:44:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab3EQVhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 080/102] VSOCK: Drop bogus __init annotation from vsock_init_tables()
Date: Fri, 17 May 2013 14:36:35 -0700
Message-Id: <20130517213252.724938692@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 22ee3b57c3ff71772b0c4178404b04f5df78d501 upstream.

If gcc (e.g. 4.1.2) decides not to inline vsock_init_tables(), this will
cause a section mismatch:

WARNING: net/vmw_vsock/vsock.o(.text+0x1bc): Section mismatch in reference from the function __vsock_core_init() to the function .init.text:vsock_init_tables()
The function __vsock_core_init() references
the function __init vsock_init_tables().
This is often because __vsock_core_init lacks a __init
annotation or the annotation of vsock_init_tables is wrong.

This may cause crashes if VSOCKETS=y and VMWARE_VMCI_VSOCKETS=m.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/vmw_vsock/af_vsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -165,7 +165,7 @@ static struct list_head vsock_bind_table
 static struct list_head vsock_connected_table[VSOCK_HASH_SIZE];
 static DEFINE_SPINLOCK(vsock_table_lock);
 
-static __init void vsock_init_tables(void)
+static void vsock_init_tables(void)
 {
 	int i;
 



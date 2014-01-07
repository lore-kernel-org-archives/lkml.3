Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaAGO6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:58:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21661 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAGO6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:58:36 -0500
Date: Tue, 7 Jan 2014 09:58:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, xen-devel@lists.xenproject.org
Subject: Re: randconfig build error with next-20140107, in
 arch/x86/xen/grant-table.c
Message-ID: <20140107145808.GA4111@phenom.dumpdata.com>
References: <CA+r1ZhgQ7vMjLdE7GDbb5_eEXxsKtEg8L47PbBv2aX571qRYow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+r1ZhgQ7vMjLdE7GDbb5_eEXxsKtEg8L47PbBv2aX571qRYow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 07:03:50AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> arch/x86/xen/grant-table.c: In function ‘xen_pvh_gnttab_setup’:
> arch/x86/xen/grant-table.c:181:2: error: implicit declaration of
> function ‘xen_pvh_domain’ [-Werror=implicit-function-declaration]
>   if (!xen_pvh_domain())
>   ^
> cc1: some warnings being treated as errors
> make[2]: *** [arch/x86/xen/grant-table.o] Error 1

And this fixes it:

>From dc5fadd89408a562b6b55566af061ad551a03b5c Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Tue, 7 Jan 2014 09:56:06 -0500
Subject: [PATCH] xen/pvh: Fix compile issues with xen_pvh_domain()

Oddly enough it compiles for my ancient compiler but with
the supplied .config it does blow up. Fix is easy enough.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/grant-table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 2d71979..103c93f 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -128,6 +128,7 @@ void arch_gnttab_unmap(void *shared, unsigned long nr_gframes)
 #ifdef CONFIG_XEN_PVH
 #include <xen/balloon.h>
 #include <xen/events.h>
+#include <xen/xen.h>
 #include <linux/slab.h>
 static int __init xlated_setup_gnttab_pages(void)
 {
-- 
1.8.3.1


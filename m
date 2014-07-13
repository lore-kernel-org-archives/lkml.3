Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaGMKAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 06:00:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50541 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaGMKAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 06:00:04 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1405199388-5692-2-git-send-email-daniel.kiper@oracle.com>
References: <1405199388-5692-1-git-send-email-daniel.kiper@oracle.com> <1405199388-5692-2-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v2 1/2] xen: Silence compiler warnings
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Sun, 13 Jul 2014 05:59:18 -0400
To: Daniel Kiper <daniel.kiper@oracle.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xenproject.org
CC: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, matt.fleming@intel.com,
        mingo@redhat.com, stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Message-ID: <a686b87e-a1db-4a08-9b92-86b37e7d518c@email.android.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On July 12, 2014 5:09:47 PM EDT, Daniel Kiper <daniel.kiper@oracle.com> wrote:
>Add inline keyword to silence the following compiler
>warnings if xen_efi_probe() is not used:
>
>  CC      arch/x86/xen/setup.o
>In file included from arch/x86/xen/xen-ops.h:7:0,
>                 from arch/x86/xen/setup.c:31:
>include/xen/xen-ops.h:43:35: warning: ‘xen_efi_probe’ defined but not
>used [-Wunused-function]
>
>Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>

Reviewed-by: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
>---
> include/xen/xen-ops.h |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
>index 771bbba..7491ee5 100644
>--- a/include/xen/xen-ops.h
>+++ b/include/xen/xen-ops.h
>@@ -40,7 +40,7 @@ bool xen_running_on_version_or_later(unsigned int
>major, unsigned int minor);
> #ifdef CONFIG_XEN_EFI
> extern efi_system_table_t *xen_efi_probe(void);
> #else
>-static efi_system_table_t __init *xen_efi_probe(void)
>+static inline efi_system_table_t __init *xen_efi_probe(void)
> {
> 	return NULL;
> }



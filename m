Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaKXLjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:39:24 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:65512 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaKXLjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:39:22 -0500
Message-ID: <547318E5.8070408@redhat.com>
Date: Mon, 24 Nov 2014 12:39:17 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [CFT PATCH 0/2] KVM: support XSAVES usage in the host
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com> <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com>
In-Reply-To: <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/11/2014 09:16, Nadav Amit wrote:
> I’ll try to check it tomorrow (I don’t have access to the failing machine at the moment).

Thanks, you'll need to squash this in:

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 4c540c4719d8..0de1fae2bdf0 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -738,3 +738,4 @@ void *get_xsave_addr(struct xsave_struct *xsave, int xstate)
 
 	return (void *)xsave + xstate_comp_offsets[feature];
 }
+EXPORT_SYMBOL_GPL(get_xsave_addr);

Paolo

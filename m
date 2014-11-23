Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaKWIQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 03:16:19 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62918 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaKWIQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 03:16:18 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [CFT PATCH 0/2] KVM: support XSAVES usage in the host
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1416594678-13011-1-git-send-email-pbonzini@redhat.com>
Date: Sun, 23 Nov 2014 10:16:20 +0200
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com>
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I’ll try to check it tomorrow (I don’t have access to the failing machine at the moment).

Thanks for the quick response.

Nadav

> On Nov 21, 2014, at 20:31, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> The first patch ensures that XSAVES is not exposed in the guest until
> we emulate MSR_IA32_XSS.  The second exports XSAVE data in the correct
> format.
> 
> I tested these on a non-XSAVES system so they should not be completely
> broken, but I need some help.  I am not even sure which XSAVE states
> are _not_ enabled, and thus compacted, in Linux.
> 
> Note that these patches do not add support for XSAVES in the guest yet,
> since MSR_IA32_XSS is not emulated.
> 
> If they fix the bug Nadav reported, I'll add Reported-by and commit.
> 
> Thanks,
> 
> Paolo
> 
> Paolo Bonzini (2):
>  kvm: x86: mask out XSAVES
>  KVM: x86: support XSAVES usage in the host
> 
> arch/x86/kvm/cpuid.c | 11 ++++++++++-
> arch/x86/kvm/x86.c   | 48 +++++++++++++++++++++++++++++++++++++++++++-----
> 2 files changed, 53 insertions(+), 6 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


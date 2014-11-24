Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaKXSbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:31:44 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33083 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaKXSbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:31:34 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [CFT PATCH 0/2] KVM: support XSAVES usage in the host
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <547370A4.3070707@redhat.com>
Date: Mon, 24 Nov 2014 20:31:30 +0200
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <BEFBDB39-E273-45AF-AB9F-B80A41192FF6@gmail.com>
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com> <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com> <547318E5.8070408@redhat.com> <DAC65E0B-06CC-4B34-85B2-72AD5F86826B@gmail.com> <547370A4.3070707@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Nov 24, 2014, at 19:53, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> 
> 
> On 24/11/2014 16:28, Nadav Amit wrote:
>> 
>> Since kvm_load_guest_fpu is called before the guest_fpu is ever stored, there are 2 more problems that currently cause #GP:
>> 1. XCOMP_BV[63] = 0
>> 2. XSTATE_BV sets a bit (including bit 63) that is not set in XCOMP_BV (XCOMP_BV is initialised to zero).
>> 
>> [see SDM 13.11 "OPERATION OF XRSTORS”]
>> 
>> Once I initialise XCOMP_BV to (1ull << 63) | XSTATE_BV, the guest runs successfully.
>> I have not checked any other qemu functionality that might be affected by the patch.
> 
> I posted patches that assume that QEMU calls KVM_SET_XSAVE early enough.
> If this is not the case, can you cook up and post a patch to
> kvm_arch_vcpu_init that fixes the remaining problem?

Sure. I will try to do so tomorrow.

Nadav


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761583AbbA1Ghv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:37:51 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:52360 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbbA1Ghu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:37:50 -0500
MIME-Version: 1.0
In-Reply-To: <54C80BD4.5080800@redhat.com>
References: <CACzj_yVKMMJMdNjCn=64sqgEtcG9Jn3j=JitsprWB=hNnf19Ng@mail.gmail.com>
 <54C80BD4.5080800@redhat.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 14:37:28 +0800
Message-ID: <CACzj_yUusP+=+Etz18vqGjdtKV21MDe_cGbqer30uu4JBBNKNw@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] KVM: nVMX: Enable nested apicv support.
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 6:06 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 24/01/2015 11:18, Wincy Van wrote:
>> v2 ---> v3:
>>   1. Add a new field in nested_vmx to avoid the spin lock in v2.
>>   2. Drop send eoi to L1 when doing nested interrupt delivery.
>>   3. Use hardware MSR bitmap to enable nested virtualize x2apic
>>      mode.
>
> I think the patches are mostly okay.  I made a few comments.
>

Thank you, Paolo and Yang. I can't accomplish this without your help.

> One of the things to do on top could be to avoid rebuilding the whole
> vmcs02 on every entry.  Recomputing the MSR bitmap on every vmentry is
> not particularly nice, for example.  It is not necessary unless the
> execution controls have changed.

Indeed, I was planned to do that optimization after this patch set.


Thanks,
Wincy

>
> Paolo

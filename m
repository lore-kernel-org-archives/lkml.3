Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbbA0WGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:06:19 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36354 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbbA0WGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:06:17 -0500
Message-ID: <54C80BD4.5080800@redhat.com>
Date: Tue, 27 Jan 2015 23:06:12 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH v3 0/6] KVM: nVMX: Enable nested apicv support.
References: <CACzj_yVKMMJMdNjCn=64sqgEtcG9Jn3j=JitsprWB=hNnf19Ng@mail.gmail.com>
In-Reply-To: <CACzj_yVKMMJMdNjCn=64sqgEtcG9Jn3j=JitsprWB=hNnf19Ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/01/2015 11:18, Wincy Van wrote:
> v2 ---> v3:
>   1. Add a new field in nested_vmx to avoid the spin lock in v2.
>   2. Drop send eoi to L1 when doing nested interrupt delivery.
>   3. Use hardware MSR bitmap to enable nested virtualize x2apic
>      mode.

I think the patches are mostly okay.  I made a few comments.

One of the things to do on top could be to avoid rebuilding the whole
vmcs02 on every entry.  Recomputing the MSR bitmap on every vmentry is
not particularly nice, for example.  It is not necessary unless the
execution controls have changed.

Paolo

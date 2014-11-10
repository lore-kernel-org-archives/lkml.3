Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaKJTcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:32:23 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:42263 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaKJTcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:32:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141110043350.GA3773@kernel>
References: <32d96cddbe65b897151b95a0e0f8326e404646f8.1415413387.git.luto@amacapital.net>
 <20141110043350.GA3773@kernel>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Nov 2014 11:31:57 -0800
Message-ID: <CALCETrWFuYAjxsPVOzHzjhijcYCyy51i+3g=wdZpoA4gKgQn0g@mail.gmail.com>
Subject: Re: [PATCH] x86, kvm, vmx: Always use LOAD_IA32_EFER if available
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 9, 2014 at 8:33 PM, Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
> Hi Andy,
> On Fri, Nov 07, 2014 at 06:25:18PM -0800, Andy Lutomirski wrote:
>>At least on Sandy Bridge, letting the CPU switch IA32_EFER is much
>>faster than switching it manually.
>>
>>I benchmarked this using the vmexit kvm-unit-test (single run, but
>>GOAL multiplied by 5 to do more iterations):
>>
>>Test                                  Before      After    Change
>>cpuid                                   2000       1932    -3.40%
>>vmcall                                  1914       1817    -5.07%
>>mov_from_cr8                              13         13     0.00%
>>mov_to_cr8                                19         19     0.00%
>>inl_from_pmtimer                       19164      10619   -44.59%
>>inl_from_qemu                          15662      10302   -34.22%
>
> What's the difference of IA32_EFER between guest and host in your config?
>
> IIUC,
> - NX is not consistent
>   IA32_EFER will be auto load w/ and w/o the patch.
> - SCE is not consistent
>   IA32_EFER will be switched through wrmsr(urn) w/o the patch, and auto load
>   w/ the patch.

This is with kvm-unit-test as is, so NX is consistent but SCE is different.

--Andy

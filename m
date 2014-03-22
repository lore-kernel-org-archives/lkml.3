Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbaCVHyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 03:54:17 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40278 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaCVHyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 03:54:14 -0400
Message-ID: <532D41A2.40404@redhat.com>
Date: Sat, 22 Mar 2014 08:54:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Peter Wu <peter@lekensteyn.nl>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
References: <4055058.qLAukpngnj@al> <1834280.dSicCcN9uU@al> <CAHdzE-88ZPTs_QvVLZsHs=O6TNKG61+iLH+ctGKLMdG5h6G0sg@mail.gmail.com> <57783d0c-3e75-47e1-a22a-818ad12e5f5c@email.android.com>
In-Reply-To: <57783d0c-3e75-47e1-a22a-818ad12e5f5c@email.android.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/03/2014 20:09, H. Peter Anvin ha scritto:
> Calling this a bug in the PMU code is ridiculous.  If KVM tells the
> system it os a specific vendor-family-model-stepping but diverges in
> behavior then it, by definition, is broken.

Yeah, this is true.  On AMD there is processor support for virtualizing 
LBR, but Intel doesn't have it.  I'm not sure if generic load/save MSR 
support could be used to do it.

Unfortunately, LBR does not have any CPUID bit to show its presence, 
unlike a lot of other perf-related features.  So, even though calling it 
a bug in perf code is an exaggeration, using rdmsr_safe makes sense.

Paolo

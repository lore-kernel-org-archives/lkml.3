Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaCVIuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 04:50:54 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:51587 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaCVIuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 04:50:51 -0400
Date: Sat, 22 Mar 2014 10:50:45 +0200
From: Gleb Natapov <gleb@kernel.org>
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: Peter Wu <peter@lekensteyn.nl>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Message-ID: <20140322085045.GA5535@minantech.com>
References: <4055058.qLAukpngnj@al>
 <1834280.dSicCcN9uU@al>
 <CAHdzE-88ZPTs_QvVLZsHs=O6TNKG61+iLH+ctGKLMdG5h6G0sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHdzE-88ZPTs_QvVLZsHs=O6TNKG61+iLH+ctGKLMdG5h6G0sg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 12:04:32PM -0700, Venkatesh Srinivas wrote:
> On Fri, Mar 21, 2014 at 10:46 AM, Peter Wu <peter@lekensteyn.nl> wrote:
[skip]

> When -cpu host is used, qemu/kvm passed the host CPUID F/M/S to the
> guest. intel_pmu_cpu_*() -> intel_pmu_lbr_reset() uses rdmsr() /
> wrmsr(), rather than the safe variants; if KVM does not support the
> particular MSRs in question, you will see a #GP(0) there. See
> https://lkml.org/lkml/2014/3/13/453 for a similar bug other PMU code.
> 
When kernel is compiled with guest support all rdmsr()/wrmsr() become _safe(),
so the question for Peter is if his guest kernel has guest support enabled?
 
--
			Gleb.

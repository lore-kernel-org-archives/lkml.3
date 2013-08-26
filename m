Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab3HZHFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:05:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab3HZHFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:05:14 -0400
Date: Mon, 26 Aug 2013 10:07:03 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Rob Landley <rob@landley.net>,
        mtosatti@redhat.com
Subject: Re: [PATCH ] Documentation/kvm: Update cpuid documentation for steal
 time and pv eoi
Message-ID: <20130826070703.GB23859@redhat.com>
References: <y>
 <1377259487-23989-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377259487-23989-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:34:47PM +0530, Raghavendra K T wrote:
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  While adding documentation for pvspinlock, I found that these two should
>  be updated. I have based this on top of pvspinlock kvm host patchset (V12)

I would change the description to merely say what the CPUID bits
mean, and what they mean is exactly that an MSR is valid.
Use KVM_FEATURE_ASYNC_PF as a template.


>  Documentation/virtual/kvm/cpuid.txt | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
> index 22ff659..15a5ac20 100644
> --- a/Documentation/virtual/kvm/cpuid.txt
> +++ b/Documentation/virtual/kvm/cpuid.txt
> @@ -43,6 +43,15 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
>  KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
>                                     ||       || writing to msr 0x4b564d02
>  ------------------------------------------------------------------------------
> +KVM_FEATURE_STEAL_TIME             ||     5 || guest accounts fine granularity
> +                                   ||       || task steal time.

I'm not sure what this phrase means.
Steal time is a host feature, not a guest feature:
IIUC if this bit is set, the hypervisor can pass the guest information
about how much time was spent running other processes outside the VM.

> enabled when
> +                                   ||       || shedstat or task delay accounting
> +                                   ||       || is supported by the host.

I think it's enabled by guest, not by host.


> +------------------------------------------------------------------------------
> +KVM_FEATURE_PV_EOI                 ||     6 || overrides the generic EOI
> +                                   ||       || implementation with an optimized
> +                                   ||       || version.

More exactly "with a paravirtualized version".

> +------------------------------------------------------------------------------
>  KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
>                                     ||       || before enabling paravirtualized
>                                     ||       || spinlock support.
> -- 
> 1.7.11.7

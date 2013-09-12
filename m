Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3ILFmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:42:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab3ILFmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:42:50 -0400
Date: Thu, 12 Sep 2013 08:44:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Rob Landley <rob@landley.net>,
        mtosatti@redhat.com
Subject: Re: [PATCH V2] Documentation/kvm: Update cpuid documentation for
 steal  time and pv eoi
Message-ID: <20130912054453.GA13116@redhat.com>
References: <y>
 <1378284526-863-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378284526-863-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 02:18:46PM +0530, Raghavendra K T wrote:
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  Changes in V2:
>   Correction in the description of steal time and added msr info (Michael S Tsirkin)

Thanks. Some comments below:

>  Documentation/virtual/kvm/cpuid.txt | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
> index 22ff659..6c4fb20 100644
> --- a/Documentation/virtual/kvm/cpuid.txt
> +++ b/Documentation/virtual/kvm/cpuid.txt
> @@ -43,6 +43,16 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
>  KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
>                                     ||       || writing to msr 0x4b564d02
>  ------------------------------------------------------------------------------
> +KVM_FEATURE_STEAL_TIME             ||     5 || Steal time available at msr
> +                                   ||       || 0x4b564d03. The feature is enabled
> +                                   ||       || by guest when host has schedstat
> +                                   ||       || or task delay accounting support.

Well I think we really should be documenting the host/guest interface
here.
After all it starts out
	A guest running on a kvm host, can check some of its features using
	cpuid.
And guests really should not try to guess whether host
has schedstat or task delay accounting support based on this bit.
So I would just say:
	"steal time can be enabled by writing to msr 0x4b564d02"
just like async pf.


> +------------------------------------------------------------------------------
> +KVM_FEATURE_PV_EOI                 ||     6 || overrides the generic EOI
> +                                   ||       || implementation with a
> +                                   ||       || paravirtualized version. Available
> +                                   ||       || at msr 0x4b564d04.

Actually there's no override: guest can still use the
standard EOI even if PV EOI MSR is enabled.

There's a detailed explanation of PV EOI in
Documentation/virtual/kvm/msr.txt
I think the following would be enough:

	"paravirtualized end of interrupt handler can be enabled by writing to msr 0x4b564d04"


> +------------------------------------------------------------------------------
>  KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
>                                     ||       || before enabling paravirtualized
>                                     ||       || spinlock support.
> -- 
> 1.7.11.7




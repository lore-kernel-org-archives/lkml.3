Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaAOXKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:10:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbaAOXKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:10:31 -0500
Date: Wed, 15 Jan 2014 21:10:15 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, glommer@gmail.com
Subject: Re: [PATCH] KVM: remove useless write to vcpu->hv_clock.tsc_timestamp
Message-ID: <20140115231015.GA30432@amt.cnet>
References: <1389805691-3183-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389805691-3183-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 06:08:11PM +0100, Paolo Bonzini wrote:
> After the previous patch from Marcelo, the comment before this write
> became obsolete.  In fact, the write is unnecessary.  The calls to
> kvm_write_tsc ultimately result in a master clock update as soon as
> all TSCs agree and the master clock is re-enabled.  This master
> clock update will rewrite tsc_timestamp.
> 
> So, together with the comment, delete the dead write too.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 842abd3..0fbdced 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1278,8 +1278,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  	kvm->arch.last_tsc_write = data;
>  	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
>  
> -	/* Reset of TSC must disable overshoot protection below */
> -	vcpu->arch.hv_clock.tsc_timestamp = 0;
>  	vcpu->arch.last_guest_tsc = data;
>  
>  	/* Keep track of which generation this VCPU has synchronized to */
> -- 
> 1.7.1

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>


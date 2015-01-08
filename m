Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbbAHQX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:23:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbbAHQX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:23:56 -0500
Message-ID: <54AEAF13.4050806@redhat.com>
Date: Thu, 08 Jan 2015 17:23:47 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] KVM: x86: allow TSC deadline timer on all hosts
References: <1420729170-23768-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1420729170-23768-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/01/2015 15:59, Radim Krčmář wrote:
> Emulation does not utilize the feature.

Indeed... nice :)

Applied to kvm/queue, thanks.

Paolo

> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 933a373..ed879f1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2743,6 +2743,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_READONLY_MEM:
>  	case KVM_CAP_HYPERV_TIME:
>  	case KVM_CAP_IOAPIC_POLARITY_IGNORED:
> +	case KVM_CAP_TSC_DEADLINE_TIMER:
>  #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
>  	case KVM_CAP_ASSIGN_DEV_IRQ:
>  	case KVM_CAP_PCI_2_3:
> @@ -2781,9 +2782,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_TSC_CONTROL:
>  		r = kvm_has_tsc_control;
>  		break;
> -	case KVM_CAP_TSC_DEADLINE_TIMER:
> -		r = boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER);
> -		break;
>  	default:
>  		r = 0;
>  		break;
> 

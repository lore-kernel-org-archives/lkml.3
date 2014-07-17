Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbaGQLF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:05:29 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:56254 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaGQLF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:05:27 -0400
Message-ID: <53C7AC51.9020208@redhat.com>
Date: Thu, 17 Jul 2014 12:58:25 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [patch V2 43/64] x86: kvm: Use ktime_get_boot_ns()
References: <20140716205018.175419210@linutronix.de> <20140716205055.838565297@linutronix.de>
In-Reply-To: <20140716205055.838565297@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/07/2014 23:04, Thomas Gleixner ha scritto:
> Use the new nanoseconds based interface and get rid of the timespec
> conversion dance.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: kvm@vger.kernel.org
> ---
>  arch/x86/kvm/x86.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> Index: tip/arch/x86/kvm/x86.c
> ===================================================================
> --- tip.orig/arch/x86/kvm/x86.c
> +++ tip/arch/x86/kvm/x86.c
> @@ -1109,11 +1109,7 @@ static void kvm_get_time_scale(uint32_t
>
>  static inline u64 get_kernel_ns(void)
>  {
> -	struct timespec ts;
> -
> -	ktime_get_ts(&ts);
> -	monotonic_to_bootbased(&ts);
> -	return timespec_to_ns(&ts);
> +	return ktime_get_boot_ns();
>  }
>
>  #ifdef CONFIG_X86_64
>
>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

I will remove get_kernel_ns if you don't do that for me...

Paolo

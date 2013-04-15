Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3DOEht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 00:37:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54508 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3DOEhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 00:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <000801ce365d$7b9bce70$72d36b50$%choi@samsung.com>
References: <000801ce365d$7b9bce70$72d36b50$%choi@samsung.com>
Date: Sun, 14 Apr 2013 21:37:47 -0700
X-Google-Sender-Auth: blxaVtRnWjSSzRqDdLwjLCTecbc
Message-ID: <CAEDV+gKXSFqS6_Q1K7b7i1PCdhAYH1_77UMzLomHLwreUsaTFQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: ARM: Fix wrong address in comment
From: Christoffer Dall <cdall@cs.columbia.edu>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 7:37 PM, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> hyp_hvc vector offset should be 0x14 and hyp_svc vector offset should be
> 0x8.
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  arch/arm/kvm/interrupts.S |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> index 8ca87ab..a8e0c2d 100644
> --- a/arch/arm/kvm/interrupts.S
> +++ b/arch/arm/kvm/interrupts.S
> @@ -235,9 +235,9 @@ ENTRY(kvm_call_hyp)
>   * instruction is issued since all traps are disabled when running the host
>   * kernel as per the Hyp-mode initialization at boot time.
>   *
> - * HVC instructions cause a trap to the vector page + offset 0x18 (see
> hyp_hvc
> + * HVC instructions cause a trap to the vector page + offset 0x14 (see
> hyp_hvc
>   * below) when the HVC instruction is called from SVC mode (i.e. a guest or
> the
> - * host kernel) and they cause a trap to the vector page + offset 0xc when
> HVC
> + * host kernel) and they cause a trap to the vector page + offset 0x8 when
> HVC
>   * instructions are called from within Hyp-mode.
>   *
>   * Hyp-ABI: Calling HYP-mode functions from host (in SVC mode):
> --
> 1.7.9.5
>
this has already been applied:
https://github.com/columbia/linux-kvm-arm/commit/0b5e3bac30c545720f7e6b026241b5f8dd832df2

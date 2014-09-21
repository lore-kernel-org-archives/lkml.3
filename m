Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaIUQkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:40:45 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:53965 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaIUQkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:40:43 -0400
MIME-Version: 1.0
In-Reply-To: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
Date: Sun, 21 Sep 2014 12:40:43 -0400
Message-ID: <CAF6AEGvhsh+jw0hoPqtgBkJcdyN2eGOMRq52w9ejJ9s8UFnyUQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Krait VFP fixes
From: Rob Clark <robdclark@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 5:43 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> These changes allow us to support VFP correctly on Krait processors.
> They also fix short vector emulation for Cortex-A15 and Krait.

fwiw, without these patches we were having problems w/ rpm in fedora,
which was looking for vfpv3 bits to decide whether the arch was
hardfloat or not.  With this patchset applied, this is solved.  So for
the series:

Tested-by: Rob Clark <robdclark@gmail.com>


> Stepan Moskovchenko (1):
>   arm: vfp: Bounce undefined instructions in vectored mode
>
> Stephen Boyd (2):
>   ARM: vfp: Workaround bad MVFR1 register on some Kraits
>   ARM: vfp: fix VFPv3 hwcap detection on non-ARM vfp implementations
>
>  arch/arm/include/asm/cputype.h | 1 +
>  arch/arm/include/asm/vfp.h     | 2 +-
>  arch/arm/mm/proc-v7.S          | 5 +++--
>  arch/arm/vfp/vfphw.S           | 6 ++++++
>  arch/arm/vfp/vfpmodule.c       | 7 +++++++
>  5 files changed, 18 insertions(+), 3 deletions(-)
>
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

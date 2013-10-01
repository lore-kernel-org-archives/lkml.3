Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3JAJaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:30:46 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:61998 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3JAJao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:30:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130924131206.d57d07f5faa5cb0773fc328c@ops.dti.ne.jp>
References: <52410F86.4040301@renesas.com>
	<20130924131206.d57d07f5faa5cb0773fc328c@ops.dti.ne.jp>
Date: Tue, 1 Oct 2013 18:30:42 +0900
Message-ID: <CANqRtoSwYgTHSzrrYNULajn45gsSJw9ST7rb=WGiHiLDsQLSTQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] sh: clkfwk: Select sh-/common- clkfwk alternatively
From: Magnus Damm <magnus.damm@gmail.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 1:12 PM,  <takasi-y@ops.dti.ne.jp> wrote:
> Make sh clock framework core depend on HAVE_MACH_CLKDEV, and
> set it
> - y on sh for backward compatibility
> - !CONFIG_COMMON_CLK on sh-mobile
> This is a preparation for migration to common clock framework
> from sh clock framework on sh-mobile.
>
> Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
> ---
>  arch/arm/Kconfig        | 2 +-
>  arch/sh/Kconfig         | 1 +
>  drivers/sh/clk/Makefile | 3 +--
>  3 files changed, 3 insertions(+), 3 deletions(-)

Hi Yoshii-san,

Thanks for your patch. I'm sure there is a reason behind this, but I'm
trying to understand why you need this modification. It looks to me
like you're trying to enable COMMON_CLK on ARCH_SHMOBILE but in my
mind it is enough to only enable COMMON_CLK in the case of
ARCH_SHMOBILE_MULTI.

During my test using ARCH_SHMOBILE_MULTI on KZM9D I omitted this patch
and only used patch 1, 2, 4, 5, and a modified 6 from your series.
This worked just fine, but I may be missing something.

Let me know if you really want to keep this patch or not. If it's not
needed for MULTIPLATFORM then I suggest that we just drop it.

Cheers,

/ magnus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaJBRlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:41:51 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:47615 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJBRlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:41:50 -0400
MIME-Version: 1.0
In-Reply-To: <201410021531.s92FV353007057@farm-0039.internal.tilera.com>
References: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com>
	<alpine.DEB.2.11.1410010004560.4455@nanos>
	<CALAqxLWHhmyDp-CeGzs6Jqzcrk-KDX_T4UQpTU79VDTL3oHdJw@mail.gmail.com>
	<20141001212439.GA12974@sisyphus.home.austad.us>
	<201410021531.s92FV353007057@farm-0039.internal.tilera.com>
Date: Thu, 2 Oct 2014 10:41:49 -0700
Message-ID: <CALAqxLWS4EBfLcjja4i3Bqt9PF-FpRJi5Em3YmhPupwd6BNr2g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] tile: add clock_gettime support to vDSO
From: John Stultz <john.stultz@linaro.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Henrik Austad <henrik@austad.us>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 7:32 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> This change adds support for clock_gettime with CLOCK_REALTIME
> and CLOCK_MONOTONIC using vDSO.  It also updates the vdso
> struct nomenclature used for the clocks to match the x86 code
> to keep it easier to update going forward.
>
> We also support the *_COARSE clockid_t, for apps that want speed
> but aren't concerned about fine-grained timestamps; this saves
> about 20 cycles per call (see http://lwn.net/Articles/342018/).
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/include/asm/vdso.h          |  15 ++--
>  arch/tile/kernel/time.c               |  45 ++++++++---
>  arch/tile/kernel/vdso/vdso.lds.S      |   2 +
>  arch/tile/kernel/vdso/vgettimeofday.c | 145 +++++++++++++++++++++++++++++-----
>  4 files changed, 172 insertions(+), 35 deletions(-)
>
> v2: use the x86 code as a model to address both John Stultz's
>     observation about sub-nanosecond updates, as well as to address
>     Thomas Gleixner's observation about minimizing time spent with
>     the seqlock held.  Note that I kept the "unlikely" that Thomas
>     doubted would help, just for parallelism with the x86 code.
> v3: rebase onto 3.17-rc7


Looks ok to me.

Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john

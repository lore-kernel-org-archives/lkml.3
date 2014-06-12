Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058AbaFLWyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 18:54:18 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:49557 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaFLWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 18:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <1402603992-12466-2-git-send-email-davidriley@chromium.org>
References: <1402603992-12466-1-git-send-email-davidriley@chromium.org>
	<1402603992-12466-2-git-send-email-davidriley@chromium.org>
Date: Thu, 12 Jun 2014 15:54:16 -0700
X-Google-Sender-Auth: vDOKnv7Ixr3cHtVM7cSl5u9cH6w
Message-ID: <CAD=FV=WoJXCcx4L7wTWgfX3LkyPBLUzWqB-KCP_fSjnzOx2MXw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] kernel: time: Add udelay_test module to validate udelay
From: Doug Anderson <dianders@chromium.org>
To: David Riley <davidriley@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Thu, Jun 12, 2014 at 1:13 PM, David Riley <davidriley@chromium.org> wrote:
> Create a module that allows udelay() to be executed to ensure that
> it is delaying at least as long as requested (with a little bit of
> error allowed).
>
> There are some configurations which don't have reliably udelay
> due to using a loop delay with cpufreq changes which should use
> a counter time based delay instead.  This test aims to identify
> those configurations where timing is unreliable.
>
> Signed-off-by: David Riley <davidriley@chromium.org>
> ---
>  kernel/time/Kconfig       |   7 ++
>  kernel/time/Makefile      |   1 +
>  kernel/time/udelay_test.c | 170 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 178 insertions(+)

Looks good to me.  Also properly demonstrates that utter brokenness
that is udelay on exynos5420 and exynos5800 right now upstream, like:

171 usecs x 100: exp=171000 allowed=170145 min=57791 avg=61586
max=435750 FAIL=99

...the same kernel on exynos5250 shows all passes (though I didn't
stress the low speeds where there are known problems due to the
intermediate freq transition).

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>

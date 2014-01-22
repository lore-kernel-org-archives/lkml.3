Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaAVVFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:05:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:58708 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbaAVVFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:05:02 -0500
Date: Wed, 22 Jan 2014 22:05:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yijing Wang <wangyijing@huawei.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH] clocksource: fix some comments typo in clocksource.c
In-Reply-To: <1388653000-9944-1-git-send-email-wangyijing@huawei.com>
Message-ID: <alpine.DEB.2.02.1401222201260.24986@ionos.tec.linutronix.de>
References: <1388653000-9944-1-git-send-email-wangyijing@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014, Yijing Wang wrote:

> Fix some trivial comments typo in kernel/time/clocksource.c

That's not a typo. Thats a left over. The function simply cannot fail
anymore. So the subject of that patch should be something like:

clocksource: Remove outdated comments

And the changelog should explain, that the functions always return 0,
so the comment is just pointless. A nice follow up on that would be to
actually make the function void instead of returning a pointless int,
but that requires to check all call sites.

Thanks,

	tglx
 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  kernel/time/clocksource.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index ba3e502..9951575 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -779,8 +779,6 @@ EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
>   * @scale:	Scale factor multiplied against freq to get clocksource hz
>   * @freq:	clocksource frequency (cycles per second) divided by scale
>   *
> - * Returns -EBUSY if registration fails, zero otherwise.
> - *
>   * This *SHOULD NOT* be called directly! Please use the
>   * clocksource_register_hz() or clocksource_register_khz helper functions.
>   */
> @@ -805,7 +803,6 @@ EXPORT_SYMBOL_GPL(__clocksource_register_scale);
>   * clocksource_register - Used to install new clocksources
>   * @cs:		clocksource to be registered
>   *
> - * Returns -EBUSY if registration fails, zero otherwise.
>   */
>  int clocksource_register(struct clocksource *cs)
>  {
> -- 
> 1.7.1
> 
> 
> 

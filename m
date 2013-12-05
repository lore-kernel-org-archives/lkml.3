Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3LEKyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:54:47 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3335 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3LEKyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:54:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Dec 2013 02:45:14 -0800
Message-ID: <52A05A21.5070100@nvidia.com>
Date: Thu, 5 Dec 2013 16:19:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>, "pavel@ucw.cz" <pavel@ucw.cz>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [REPOST PATCH V2] irq: enable all irqs unconditionally in irq_resume
References: <1385388587-16442-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1385388587-16442-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Monday 25 November 2013 07:39 PM, Laxman Dewangan wrote:
> When system enters into suspend, it disable all irqs in single
> function call. This disables EARLY_RESUME irqs also along with
> normal irqs.
>
> The EARLY_RESUME irqs get enabled in sys_core_ops->resume and
> non-EARLY_RESUME irqs get enabled in normal system resume path.
>
> When suspend_noirq failed or suspend is aborted for any reason,
> the EARLY_RESUME irqs do not get enabled as sys_core_ops->resume()
> call did not happen. It only enables the non-EARLY_RESUME irqs in normal
> disable for remaining life of system.
>
> Enable all irqs unconditionally in normal irq_resume() regardless of
> EARLY_RESUME irqs have been already enabled or not.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by-and-tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Acked-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
>

Can you please review this patch?
This patch is pending from long back for review.

Thanks,
Laxman


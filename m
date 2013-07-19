Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371Ab3GSNud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:50:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2947 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab3GSNuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:50:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 19 Jul 2013 06:50:32 -0700
Message-ID: <51E94690.1010702@nvidia.com>
Date: Fri, 19 Jul 2013 19:30:48 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: enable suspended EARLY_RESUME irqs forcefully if
 not resumed
References: <1373380343-10143-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1373380343-10143-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tuesday 09 July 2013 08:02 PM, Laxman Dewangan wrote:
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
> Add checks on normal irq_resume() whether EARLY_RESUME irqs have been
> enabled or not and if not then enable it forcefully.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---


Any feedback on this patch please?

Thanks,
Laxman

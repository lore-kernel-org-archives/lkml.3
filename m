Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3KTJ4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:56:01 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2075 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTJz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:55:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Nov 2013 01:49:58 -0800
Message-ID: <528C86C2.1070206@nvidia.com>
Date: Wed, 20 Nov 2013 15:24:10 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: Ian Campbell <ian.campbell@citrix.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: IRQF_RESUME_EARLY and errors in dpm_suspend_noirq
References: <201311201020.08158.heiko@sntech.de>
In-Reply-To: <201311201020.08158.heiko@sntech.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 November 2013 02:50 PM, Heiko Stübner wrote:
> Hi,
>
> Commit 9bab0b7fbace (genirq: Add IRQF_RESUME_EARLY and resume such IRQs
> earlier) split the suspend/resume of the irqs into two parts.
>
> The early-irqs get resumed during syscore_resume, while the rest get
> resumed by the regular resume_device_irqs.
>
> I may be blind, but where get the early-irqs resumed in the error
> path of dpm_suspend_noirq?
>
> When a suspend_noirq callback returns an error, dpm_resume_noirq gets called,
> which only calls resume_device_irqs while the suspend_device_irqs call in
> dpm_suspend_noirq suspends all irqs. So it does not seem that the early-irqs
> get resumed at all in this case.
>
I also faced same issue in our suspend failure path and posted fix 
sometime ago as
https://lkml.org/lkml/2013/8/13/373

It is still under review.

You can try this patch if it resolve the issue.

Thanks,
Laxman

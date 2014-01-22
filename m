Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaAVUpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:45:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37510 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaAVUpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:45:03 -0500
Message-ID: <52E02DCC.1000404@wwwdotorg.org>
Date: Wed, 22 Jan 2014 13:45:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH 5/5] ARM: tegra: cpuidle: use firmware call for power
 down
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com> <1390299016-14105-6-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1390299016-14105-6-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 03:10 AM, Alexandre Courbot wrote:
> Invoke the do_idle() firmware call before suspending a CPU so that the
> underlying firmware (if any) can take necessary action.

> diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c

> @@ -45,6 +46,8 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
>  
>  	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
>  
> +	call_firmware_op(do_idle);
> +
>  	cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
>  
>  	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);

Don't you need to have the kernel also *not* do something when entering
idle; doesn't the FW op replace some of the register writes that the
kernel would otherwise be doing?

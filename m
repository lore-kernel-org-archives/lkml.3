Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaBUJmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 04:42:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaBUJmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 04:42:31 -0500
Message-ID: <1392975715.5451.118.camel@marge.simpson.net>
Subject: Re: [PATCH v3] sched: keep quiescent cpu out of idle balance loop
From: Mike Galbraith <bitbucket@online.de>
To: Lei Wen <leiwen@marvell.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        preeti.lkml@gmail.com, daniel.lezcano@linaro.org,
        viresh.kumar@linaro.org, xjian@marvell.com,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Feb 2014 10:41:55 +0100
In-Reply-To: <1392974108-28778-1-git-send-email-leiwen@marvell.com>
References: <1392971691.5451.84.camel@marge.simpson.net>
	 <1392974108-28778-1-git-send-email-leiwen@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:+EOqtrADGTsOp2pAL+okrB5GyL473AbrJbjTIL9sk7L
 0BoFHcLHtEdlmz4UFqZUHGO74Ut4kZGE4r0OqfVhNp1P8matna
 PNqrpjFNAQoXqzIRKtIG0CjKa3s7wywpEbN7R3fn04JfkFl7wS
 AUA1G5A9nEN+YcBr2MX842AT7E/LBCIczL1SP0vxHLHVHBfzwr
 vC9kaDfXZNp6h51QpfGx+lgAFfiXmk8mxcpHe6e/CUWi4wKJMZ
 OBHLACd+wd8UJDQ9vNc7sAYrBrg4xqj2ndISdVcMUB8jVy/Ozy
 1XEJf+L/m3w4pWfAseAghR4+Frfxslne8JlDRzZzZts2cH3olj
 +E+3lLUfrgl1G5okBpMzQFiO1RL7epbzwVQrLaFPlh1n3KjPc4
 lsaVHtaW35TUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 17:15 +0800, Lei Wen wrote:

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 235cfa7..af30b6a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6883,6 +6883,14 @@ void nohz_balance_enter_idle(int cpu)
>  	if (!cpu_active(cpu))
>  		return;
>  
> +	/*
> +	 * If this cpu is isolated, its rq's sd member would becomes NULL.
> +	 * Base on this observation, we could exclude this cpu from nohz
> +	 * idle balance, so that it would not be disturbed.
> +	 */
> +	if (!this_rq()->sd)
> +		return;
> +
>  	if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
>  		return;

What about nohz_balance_exit_idle()?

I think Peter queued a patchlet to tell nohz balancing to go away.

-Mike


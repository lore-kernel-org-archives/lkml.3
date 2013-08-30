Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3H3Lwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:52:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44640 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab3H3Lww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:52:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Len Brown <lenb@kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] intel_idle: shrink states tables
Date: Fri, 30 Aug 2013 14:03:38 +0200
Message-ID: <6073210.Ddg7QEoeOl@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2945985.mxvmQoz8DY@amdc1032>
References: <2945985.mxvmQoz8DY@amdc1032>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 30, 2013 12:25:10 PM Bartlomiej Zolnierkiewicz wrote:
> There is no reason to define CPUIDLE_STATE_MAX (currently 10) entries
> in states tables if the driver always stops iterating over table when
> it encounters first .enter == NULL entry.
> 
> $ size drivers/idle/intel_idle.o.*
>    text    data     bss     dec     hex filename
>    2886    5440      32    8358    20a6 drivers/idle/intel_idle.o.before
>    2886    3752      32    6670    1a0e drivers/idle/intel_idle.o.after
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Len Brown <lenb@kernel.org>

Thanks, I'll queue this series up for 3.13.


> ---
>  drivers/idle/intel_idle.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index fa6964d..9c97fbb42 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -123,7 +123,7 @@ static struct cpuidle_state *cpuidle_state_table;
>   * which is also the index into the MWAIT hint array.
>   * Thus C0 is a dummy.
>   */
> -static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state nehalem_cstates[] = {
>  	{
>  		.name = "C1-NHM",
>  		.desc = "MWAIT 0x00",
> @@ -156,7 +156,7 @@ static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
>  		.enter = NULL }
>  };
>  
> -static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state snb_cstates[] = {
>  	{
>  		.name = "C1-SNB",
>  		.desc = "MWAIT 0x00",
> @@ -196,7 +196,7 @@ static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
>  		.enter = NULL }
>  };
>  
> -static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state ivb_cstates[] = {
>  	{
>  		.name = "C1-IVB",
>  		.desc = "MWAIT 0x00",
> @@ -236,7 +236,7 @@ static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
>  		.enter = NULL }
>  };
>  
> -static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state hsw_cstates[] = {
>  	{
>  		.name = "C1-HSW",
>  		.desc = "MWAIT 0x00",
> @@ -297,7 +297,7 @@ static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
>  		.enter = NULL }
>  };
>  
> -static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state atom_cstates[] = {
>  	{
>  		.name = "C1E-ATM",
>  		.desc = "MWAIT 0x00",
> @@ -628,7 +628,7 @@ static int intel_idle_cpu_init(int cpu)
>  		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
>  
>  		if (cpuidle_state_table[cstate].enter == NULL)
> -			continue;
> +			break;
>  
>  		if (cstate + 1 > max_cstate) {
>  			printk(PREFIX "max_cstate %d reached\n", max_cstate);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

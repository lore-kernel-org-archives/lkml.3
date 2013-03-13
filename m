Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3CMQ3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:29:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65454 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3CMQ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:29:15 -0400
MIME-Version: 1.0
In-Reply-To: <1362922535-25172-1-git-send-email-mihai.stirbat@gmail.com>
References: <1362922535-25172-1-git-send-email-mihai.stirbat@gmail.com>
Date: Wed, 13 Mar 2013 17:29:14 +0100
Message-ID: <CAKfTPtA374ZaW_cJYQbjR5qz6iAVXkgMa6=i5OMDUXncqMnrXQ@mail.gmail.com>
Subject: Re: [PATCH] topology: removed kzalloc return value cast
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Mihai Stirbat <mihai.stirbat@gmail.com>
Cc: linux@arm.linux.org.uk, namhyung@kernel.org, lorenzo.pieralisi@arm.com,
        a.p.zijlstra@chello.nl, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 March 2013 21:35, Mihai Stirbat <mihai.stirbat@gmail.com> wrote:
> Signed-off-by: Mihai Stirbat <mihai.stirbat@gmail.com>
> ---
>  arch/arm/kernel/topology.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 79282eb..f10316b 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -100,7 +100,7 @@ static void __init parse_dt_topology(void)
>         int alloc_size, cpu = 0;
>
>         alloc_size = nr_cpu_ids * sizeof(struct cpu_capacity);
> -       cpu_capacity = (struct cpu_capacity *)kzalloc(alloc_size, GFP_NOWAIT);
> +       cpu_capacity = kzalloc(alloc_size, GFP_NOWAIT);

you're right

Acked-by: Vincent Guittot <vincent.guittot@linaro.org>

>
>         while ((cn = of_find_node_by_type(cn, "cpu"))) {
>                 const u32 *rate, *reg;
> --
> 1.7.10.4
>

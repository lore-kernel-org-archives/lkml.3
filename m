Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaF1TxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:53:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:42221 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbaF1TxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 15:53:14 -0400
Message-ID: <53AF1D25.10406@kernel.org>
Date: Sat, 28 Jun 2014 15:53:09 -0400
From: Sasha Levin <sashal@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, rth@twiddle.net
CC: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FIXME of file toploogy.h for alpha cpus
References: <1403928469-9452-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1403928469-9452-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 12:07 AM, Nicholas Krause wrote:
> This patch fixs the FIXME message in the function *cpumask_of_node
> for using this function multiple times and the issue with recaluting
> the cpu node mask when reusing this function.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/alpha/include/asm/topology.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/alpha/include/asm/topology.h b/arch/alpha/include/asm/topology.h
> index 9251e13..d301f66 100644
> --- a/arch/alpha/include/asm/topology.h
> +++ b/arch/alpha/include/asm/topology.h
> @@ -31,6 +31,9 @@ static const struct cpumask *cpumask_of_node(int node)
>  	if (node == -1)
>  		return cpu_all_mask;
>  
> +	else if (node == &node_to_cpumask_map[node])
> +		return &node_to_cpumask_map[node];
> +
>  	cpumask_clear(&node_to_cpumask_map[node]);
>  
>  	for_each_online_cpu(cpu) {
> 

Since this patch doesn't even compile, care to tell us how you tested it?


Thanks,
Sasha

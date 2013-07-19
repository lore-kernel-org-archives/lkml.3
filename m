Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3GSOH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:07:57 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:58616 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3GSOH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:07:56 -0400
Message-ID: <51E94841.1020202@cogentembedded.com>
Date: Fri, 19 Jul 2013 18:08:01 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Tesar <mtesar@redhat.com>
CC: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl net: Keep tcp_syn_retries inside the boundary
References: <1374230873-30070-1-git-send-email-mtesar@redhat.com>
In-Reply-To: <1374230873-30070-1-git-send-email-mtesar@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-07-2013 14:47, Michal Tesar wrote:

> Limit the min/max value passed to the
> /proc/sys/net/ipv4/tcp_syn_retries.

> Signed-off-by: Michal Tesar <mtesar@redhat.com>
> ---
>   net/ipv4/sysctl_net_ipv4.c |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)

> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index b2c123c..fdc2a17 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
[...]
> @@ -332,7 +334,9 @@ static struct ctl_table ipv4_table[] = {
>   		.data		= &sysctl_tcp_syn_retries,
>   		.maxlen		= sizeof(int),
>   		.mode		= 0644,
> -		.proc_handler	= proc_dointvec
> +		.proc_handler	= proc_dointvec_minmax,
> +        .extra1     = &tcp_syn_retries_min,
> +        .extra2     = &tcp_syn_retries_max

    You should indent with tabs, not spaces.

WBR, Sergei


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaFHMQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:16:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbaFHMQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:16:27 -0400
Message-ID: <5394540D.2030507@redhat.com>
Date: Sun, 08 Jun 2014 14:16:13 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, shemminger@osdl.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, hannes@stressinduktion.org
Subject: Re: [PATCH 3/7] lib/random32.c: Replace an #ifdef with a stub prandom_state_selftest()
References: <20140607082235.9839.qmail@ns.horizon.com>
In-Reply-To: <20140607082235.9839.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2014 10:22 AM, George Spelvin wrote:
> The preferred Linux style for optional features is to define
> no-op stub functions rather than wrap each call site in #ifdef.
>
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
>   lib/random32.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/lib/random32.c b/lib/random32.c
> index 2e7c15c0..e8f3557b 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -40,6 +40,8 @@
>
>   #ifdef CONFIG_RANDOM32_SELFTEST
>   static void __init prandom_state_selftest(void);
> +#else
> +#define prandom_state_selftest() (void)0

Fine by me. I think you can remove this '(void)0' here, though.

>   #endif
>
>   static DEFINE_PER_CPU(struct rnd_state, net_rand_state);
> @@ -188,9 +190,7 @@ static int __init prandom_init(void)
>   {
>   	int i;
>
> -#ifdef CONFIG_RANDOM32_SELFTEST
>   	prandom_state_selftest();
> -#endif
>
>   	for_each_possible_cpu(i) {
>   		struct rnd_state *state = &per_cpu(net_rand_state,i);
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaFHKga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 06:36:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbaFHKgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 06:36:25 -0400
Message-ID: <53943C95.4060200@redhat.com>
Date: Sun, 08 Jun 2014 12:36:05 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, shemminger@osdl.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, hannes@stressinduktion.org
Subject: Re: [PATCH 7/7] lib/random32.c: Remove redundant U suffixes on integers
References: <20140607083121.10274.qmail@ns.horizon.com>
In-Reply-To: <20140607083121.10274.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please also Cc Hannes in your series. ]

On 06/07/2014 10:31 AM, George Spelvin wrote:
> Get rid of a few of the extraneous U suffixes on ordinary integers.
>
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
>   lib/random32.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/lib/random32.c b/lib/random32.c
> index 9cc410dd..ad0c2ed1 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -58,10 +58,10 @@ u32 prandom_u32_state(struct rnd_state *state)
>   {
>   #define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
>
> -	state->s1 = TAUSWORTHE(state->s1,  6U, 13U, 4294967294U, 18U);
> -	state->s2 = TAUSWORTHE(state->s2,  2U, 27U, 4294967288U,  2U);
> -	state->s3 = TAUSWORTHE(state->s3, 13U, 21U, 4294967280U,  7U);
> -	state->s4 = TAUSWORTHE(state->s4,  3U, 12U, 4294967168U, 13U);
> +	state->s1 = TAUSWORTHE(state->s1,  6, 13, 4294967294U, 18);
> +	state->s2 = TAUSWORTHE(state->s2,  2, 27, 4294967288U,  2);
> +	state->s3 = TAUSWORTHE(state->s3, 13, 21, 4294967280U,  7);
> +	state->s4 = TAUSWORTHE(state->s4,  3, 12, 4294967168U, 13);

I don't see the point in why we _need_ to change this here.

>   	return (state->s1 ^ state->s2 ^ state->s3 ^ state->s4);
>   }
> @@ -77,9 +77,8 @@ EXPORT_SYMBOL(prandom_u32_state);
>   u32 prandom_u32(void)
>   {
>   	struct rnd_state *state = &get_cpu_var(net_rand_state);
> -	u32 res;
> +	u32 res = prandom_u32_state(state);
>
> -	res = prandom_u32_state(state);
>   	put_cpu_var(state);

Ditto.

>   	return res;
>

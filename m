Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaAPJWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:22:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaAPJWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:22:17 -0500
Message-ID: <52D7A4BC.7080703@redhat.com>
Date: Thu, 16 Jan 2014 10:22:04 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Zawadzki <darkjames-ws@darkjames.pl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH net-next 1/2] random32: add prandom_u32_lt_N and convert
 "misuses" of reciprocal_divide
References: <1389828228-30312-1-git-send-email-dborkman@redhat.com>  <1389828228-30312-2-git-send-email-dborkman@redhat.com> <1389832172.14001.41.camel@joe-AO722>
In-Reply-To: <1389832172.14001.41.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 01:29 AM, Joe Perches wrote:
> On Thu, 2014-01-16 at 00:23 +0100, Daniel Borkmann wrote:
>> Many functions have open coded a function that return a random
>> number in range [0,N-1]. Also, only because we have a function
>> that is named reciprocal_divide(), it has not much to do with
>> the pupose where it is being used when a previous reciprocal_value()
>> has not been obtained.
>
> prandom_u32_lt_N?
>
> I do not like the camelcase name and thought the
> prandom_u32_max was better.

Hm, you wanted to have the name intuitive, right ... so
u32 prandom_u32_lt_N(u32 N) suggests "less then N". If you
are saying "_max" here, then you should keep in mind that
the maximum result you get from here is "max-1", not "max".
But whatever, it's just a name.

> How about using
>
> u32 prandom_u32_max(u32 max)
> {
> 	return (u32)(((u64)prandom_u32() * max) >> 32);
> }
>
> u32 prandom_u32_range(u32 a, u32 b)
> {
> 	if (b < a)
> 		swap(a, b);
>
> 	return a + (u32)(((u64)prandom_u32() * (b - a)) >> 32);
> }

I didn't introduce the last one as it wasn't used in the patch.

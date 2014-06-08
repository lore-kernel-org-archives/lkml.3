Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaFHM2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbaFHM2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:28:23 -0400
Message-ID: <539456DD.4020601@redhat.com>
Date: Sun, 08 Jun 2014 14:28:13 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
Subject: Re: [PATCH 6/7] lib/random32.c: Randomize timeout to the millisecond,
 not the second
References: <20140608113000.5423.qmail@ns.horizon.com>
In-Reply-To: <20140608113000.5423.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 01:30 PM, George Spelvin wrote:
>> Fine by me this cleanup, although not strictly needed.
>
> Agreed.  The timer slack is set to HZ (1 second) anyway.
>
> It just dawned on me that a simpler and more efficient way to do this
> (which I'll do in v2 of this) would be:

Note, when you talk about efficiency here, this is called once every
40+ secs ... ;)

>     	/* reseed every ~60 seconds, in [40 .. 80) interval with slack */
> -	expires = 40 + (prandom_u32() % 40);
> -	seed_timer.expires = jiffies + msecs_to_jiffies(expires * MSEC_PER_SEC);
> +	expires = 40*HZ + prandom_u32_max(40*HZ);
> +	seed_timer.expires = jiffies + expires;
>
> That avoids calling msecs_to_jiffies entirely.
>

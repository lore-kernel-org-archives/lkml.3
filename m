Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3BUOXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 09:23:04 -0500
Received: from mail.atsec.com ([195.30.99.214]:34319 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab3BUOXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 09:23:03 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2013 09:23:02 EST
Message-ID: <51262C62.4040707@chronox.de>
Date: Thu, 21 Feb 2013 15:17:06 +0100
From: Stephan Mueller <smueller@chronox.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Phil Carmody <pc+lkml@asdf.org>
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
References: <20130221140712.GA11550@fatphil.org>
In-Reply-To: <20130221140712.GA11550@fatphil.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.02.2013 15:07:12, +0100, Phil Carmody <pc+lkml@asdf.org> wrote:

Hi Phil,
> Apologies if this is misthreaded, I had to hand-craft the headers.
>
>> The patch offers an entropy generator based on CPU timing jitter. The 
>> entropy collector has the following properties:
>>
>> * it does not maintain any state and therefore does not need any seed
> What is this "pool" if it's not "state"?

There is no state between calls. Of course, you need a scratchpad to do
calculations.
>
>> /* Entropy pool of the RNG which is filled upon each request for entropy */
>> struct rand_data
> And, from looking at jitterentropy_entropy_calc(), it seems to think that
> the [source producing the] following sequence of timestamps:
>
> 1000, 1010, 1030, 1050, 1060, 1080, 1090, 1110, 1120, ...
> i.e. with absolutely metronomic deltas of 10, 20, 10, 20, 10, 20, ...
>
> has 4 bit of entropy per reading. I hope I don't have to explicitly say
> that it clearly it has 0 bits of entropy.

I can always hand-craft some deltas that the entropy heuristics come up
with a positive value although there is none. You can make the same
statement for the entropy calculation of random.c. So, that example is
not applicable. I am working on showing that the jitter has entropy. I
will come back.
>
> Entropy harvesting is quite hard - entropy estimation is unimaginably harder.

This is a statement that does not make sense. You CANNOT per definition
calculate entropy! The entropy calculation shall ensure that the
collector in the worst case is called as often to make sure that there
is enough entropy. In other circumstances, it shall just save time!

Ciao
Stephan

> Phil

-- 
| Cui bono? |


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaFHM1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:27:17 -0400
Received: from ns.horizon.com ([71.41.210.147]:57679 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753608AbaFHM1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:27:16 -0400
Date: 8 Jun 2014 08:27:13 -0400
Message-ID: <20140608122713.1627.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dborkman@redhat.com, linux@horizon.com
Subject: Re: [PATCH 3/7] lib/random32.c: Replace an #ifdef with a stub prandom_state_selftest()
Cc: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
In-Reply-To: <5394540D.2030507@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>   #ifdef CONFIG_RANDOM32_SELFTEST
>>   static void __init prandom_state_selftest(void);
>> +#else
>> +#define prandom_state_selftest() (void)0

> Fine by me. I think you can remove this '(void)0' here, though.

That's the standard way to write a no-op statement in C.

I seem to recall there's a reason that the empty string can cause problems
in some syntactic contexts, but I can't figure out what the situation is.

At first, I thought of the obvious:

if (condition)
	prandom_state_selftest();
unconditional_code();

... but the semicolon makes that work.  I'll try to remember
the reason.

(I know that nobody uses it in any such context, but it's
good manners to make a function-like macro behave as exactly
like a function as possible.)

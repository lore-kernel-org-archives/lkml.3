Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaFIA2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 20:28:31 -0400
Received: from ns.horizon.com ([71.41.210.147]:39277 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753098AbaFIA22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 20:28:28 -0400
Date: 8 Jun 2014 20:28:25 -0400
Message-ID: <20140609002825.20757.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dborkman@redhat.com, hannes@stressinduktion.org
Subject: Re: [PATCH 5/7] lib/random32.c: Make prandom_u32_max efficient for powers of 2
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux@horizon.com,
        shemminger@osdl.org, tytso@mit.edu
In-Reply-To: <5394C15D.3020507@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Borkmann wrote:
> On 06/08/2014 07:34 PM, Hannes Frederic Sowa wrote:
>> Please check this as it makes the code more complicated and I doubt it is worth it.
>
> Agreed.

Just to clarify, the goal is to be able to replace "prandom_u32() %
range" all over the kernel with "prandom_u32_max(range)" and promise
people that it's guaranteed to be just as good.

My goal is a one-time cleanup to eliminate "prandom_u32() % range" so
people will stop cutting and pasting it into new code.

(FIXME: Add a kdoc update on the subject.)

It uglifies the random32 code for sure, but by encapsulating the cleverness
it lets all the call sites be simpler and reduces arguments about the change.

E.g. have a look at all the prandom_u32 calls in net/core/pktgen.c.

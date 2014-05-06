Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbaEFOVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:21:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23738 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaEFOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:21:04 -0400
Message-ID: <5368EFA0.2040506@oracle.com>
Date: Tue, 06 May 2014 10:20:16 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: sched,numa: invalid memory access in account_entity_dequeue
References: <5364EC10.9090900@oracle.com> <20140506110838.GE11096@twins.programming.kicks-ass.net> <5368D43D.5050601@oracle.com> <20140506134016.GL11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140506134016.GL11096@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/06/2014 09:40 AM, Peter Zijlstra wrote:
> On Tue, May 06, 2014 at 08:23:25AM -0400, Sasha Levin wrote:
>>>>> I suppose you've scripted this addr2line -ie vmlinux for all addresses in this splat?
>>> 
>>> Yeah, I'm trying to get that script upstream (https://lkml.org/lkml/2014/3/29/1) since it seems to simplify looking at stack traces.
> Seems like a nice addition to scripts/ indeed. Although Linus doesn't seem to like it much:
> 
> http://marc.info/?l=linux-kernel&m=139862933908922

Linus objected to the original version of the script using the hex numbers
he wants to throw out instead of resolving it from 'nm vmlinux', which was
fixed in later versions.

Since there were no objections from Linus after all the fixes that were asked
for I'll try pinging him again next merge window, but until then I'll add some
more features that were asked for like caching and code decoding and try again :)


Thanks,
Sasha
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTaO+fAAoJEN6mb/eXdyzcNFQP/1cSr+MVTKBLQdI0p6esCSx0
nEMdSbJpU/P98cK2kuWffYHL4IUs9cfAeumOrUbWaDWBatetDxH1e557k53VW7aQ
mmaNXrtaDQBFc3lzicDXxdjgjttf+ljkLFzBUexGhw01DsgRHa1DodD9ONcZ5Dav
bsy9sWtEfUyiDNln6NtGxTSlMUXehIpLDVoqKcxzOg5wm6sSs+JF9w6YvohNuEtS
OvrHKZv0XiV+Stv/496lntbmyVoVNpuhpzm3RmAxGy6VspRJLWlc8srIHWVY6KZG
zP/5WvrgGawQqbMGfxKUYDplRSGzupm8xDdpVSZ8RQLfWVEqswEHjO0wRt5+8yqt
r62nXPLcepjJcYppN7t6QqJ18zWTDGAOhvjNb8Yl0+YkLO/9URFetAiYq+frHVYN
WAjEBBQdWiBS3akllFkf8hGEnF4vbhBHdZfBS0irbGG8eyZH3kaLhS5lJzyTnWKr
oHrQ2YPrtDJjTQ1WWNiKU23GouFUHsRS/dK51VPQrUVKn5p8T6O9JSVMC0HMJkji
lRfgOJM3YTB51Y3CJ9N5t8jP0l8ynLllzj4hrLN0KzfkdmYGk0yLzCuSy8BlPzyL
bgN0u2ZEIEWyhlB/RVv/NA2gC6yC3xmypQgAbyQyIjqFWH6+s1hhcV5D+QnW6kN0
UZVTCyFUo4XatOhKqnj6
=6rXX
-----END PGP SIGNATURE-----

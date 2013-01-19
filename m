Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3ASDGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 22:06:51 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36557 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab3ASDGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 22:06:50 -0500
Date: Sat, 19 Jan 2013 12:06:47 +0900
From: Norbert Preining <preining@logic.at>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: dire state of rtl8192se driver in 3.7
Message-ID: <20130119030647.GG31262@gamma.logic.tuwien.ac.at>
References: <20121222150909.GA3979@gamma.logic.tuwien.ac.at> <50D5E194.3050503@lwfinger.net> <20121222225543.GA21544@gamma.logic.tuwien.ac.at> <50D66313.3000208@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D66313.3000208@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry, hi all,

it is some time that I didn't post, but here I want to come back to
this item.

On Sa, 22 Dez 2012, Larry Finger wrote:
>> But the DMAR item I also reported points to a real problem I guess.
>
> Yes, I would agree.

That seems to be gone with current kernels 3.8.0-rc3

I have had the hanging issue today again, but this time it showed 
a very interesting rythm, that might help to understand.
Pinging my router I normally have about ~1ms response time.
When it hanged (and this is now several thousand seconds long test)
the hang times are *always very close:
	4sec
	3sec
	2sec
	1sec
is one block. This block might repeat a few times, or only once, but it
is always in this rythm:
64 bytes from 192.168.0.1: icmp_req=407 ttl=255 time=1.23 ms
64 bytes from 192.168.0.1: icmp_req=408 ttl=255 time=1.89 ms
64 bytes from 192.168.0.1: icmp_req=409 ttl=255 time=3925 ms
64 bytes from 192.168.0.1: icmp_req=410 ttl=255 time=2918 ms
64 bytes from 192.168.0.1: icmp_req=411 ttl=255 time=1910 ms
64 bytes from 192.168.0.1: icmp_req=412 ttl=255 time=903 ms
64 bytes from 192.168.0.1: icmp_req=413 ttl=255 time=1.15 ms
...
64 bytes from 192.168.0.1: icmp_req=418 ttl=255 time=1.16 ms
64 bytes from 192.168.0.1: icmp_req=419 ttl=255 time=4040 ms
64 bytes from 192.168.0.1: icmp_req=420 ttl=255 time=3033 ms
64 bytes from 192.168.0.1: icmp_req=421 ttl=255 time=2025 ms
64 bytes from 192.168.0.1: icmp_req=422 ttl=255 time=1018 ms
64 bytes from 192.168.0.1: icmp_req=423 ttl=255 time=4087 ms
64 bytes from 192.168.0.1: icmp_req=424 ttl=255 time=3081 ms
64 bytes from 192.168.0.1: icmp_req=425 ttl=255 time=2073 ms
64 bytes from 192.168.0.1: icmp_req=426 ttl=255 time=1065 ms
64 bytes from 192.168.0.1: icmp_req=427 ttl=255 time=4124 ms
64 bytes from 192.168.0.1: icmp_req=428 ttl=255 time=3121 ms
64 bytes from 192.168.0.1: icmp_req=429 ttl=255 time=2114 ms
64 bytes from 192.168.0.1: icmp_req=430 ttl=255 time=1109 ms
64 bytes from 192.168.0.1: icmp_req=431 ttl=255 time=4169 ms
64 bytes from 192.168.0.1: icmp_req=432 ttl=255 time=3163 ms
64 bytes from 192.168.0.1: icmp_req=433 ttl=255 time=2155 ms
64 bytes from 192.168.0.1: icmp_req=434 ttl=255 time=1147 ms
....
64 bytes from 192.168.0.1: icmp_req=521 ttl=255 time=1.30 ms
64 bytes from 192.168.0.1: icmp_req=522 ttl=255 time=1.25 ms
64 bytes from 192.168.0.1: icmp_req=523 ttl=255 time=4300 ms
64 bytes from 192.168.0.1: icmp_req=524 ttl=255 time=3293 ms
64 bytes from 192.168.0.1: icmp_req=525 ttl=255 time=2295 ms
64 bytes from 192.168.0.1: icmp_req=526 ttl=255 time=1287 ms
64 bytes from 192.168.0.1: icmp_req=527 ttl=255 time=4357 ms
64 bytes from 192.168.0.1: icmp_req=528 ttl=255 time=3351 ms
64 bytes from 192.168.0.1: icmp_req=529 ttl=255 time=2344 ms
64 bytes from 192.168.0.1: icmp_req=530 ttl=255 time=1336 ms
64 bytes from 192.168.0.1: icmp_req=531 ttl=255 time=4408 ms
64 bytes from 192.168.0.1: icmp_req=532 ttl=255 time=3403 ms
64 bytes from 192.168.0.1: icmp_req=533 ttl=255 time=2395 ms
64 bytes from 192.168.0.1: icmp_req=534 ttl=255 time=1387 ms
64 bytes from 192.168.0.1: icmp_req=535 ttl=255 time=4453 ms
64 bytes from 192.168.0.1: icmp_req=536 ttl=255 time=3449 ms
64 bytes from 192.168.0.1: icmp_req=537 ttl=255 time=2441 ms
64 bytes from 192.168.0.1: icmp_req=538 ttl=255 time=1433 ms
64 bytes from 192.168.0.1: icmp_req=539 ttl=255 time=4499 ms
...

In addition, the responses for these blocks come *together*,
not after 4sec the first, then after 3 sec the next. No.
It is wait 10 sec, bammmm, all 4, wait 10secs, bam all 4.

Does that ring *any* bell*


Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3ARP4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:56:25 -0500
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:55528 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754520Ab3ARP4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:56:22 -0500
X-Panda: scanned!
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,jason@warr.net,:::::::::::::,RULES_HIT:355:379:599:601:854:945:947:973:988:989:1187:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2198:2199:2379:2393:2553:2559:2562:2689:2693:2828:3027:3138:3139:3140:3141:3142:3865:3866:3867:3868:3869:3870:3871:3872:3873:3874:4250:4362:4471:5007:6119:6120:7652:7860:7901:7903:7974:10004:10400:10848:11658:11914:12220:12517:12519:12663:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 6A61736F6E40776172722E6E6574
X-Filterd-Recvd-Size: 4834
Message-ID: <50F970A3.4000403@warr.net>
Date: Fri, 18 Jan 2013 09:56:19 -0600
From: Jason Warr <jason@warr.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Amit Kale <akale@stec-inc.com>
CC: "thornber@redhat.com" <thornber@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD> <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD> <20130116104546.GA3869@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD> <20130117132620.GA2438@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD> <50F844A3.9020300@warr.net> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/18/2013 03:08 AM, Amit Kale wrote:
>> > Can you explain what you mean by that in a little more detail?
> Let's say latency of a block device is 10ms for 4kB requests. With single threaded IO, the throughput will be 4kB/10ms = 400kB/s. If the device is capable of more throughput, a multithreaded IO will generate more throughput. So with 2 threads the throughput will be roughly 800kB/s. We can keep increasing the number of threads resulting in an approximately linear throughput. It'll saturate at the maximum capacity the device has. So it could saturate at perhaps at 8MB/s. Increasing the number of threads beyond this will not increase throughput.
>
> This is a simplistic computation. Throughput, latency and number of threads are related in a more complex relationship. Latency is still important, but throughput is more important.
>
> The way all this matters for SSD caching is, caching will typically show a higher latency compared to the base SSD, even for a 100% hit ratio. It may be possible to reach the maximum throughput achievable with the base SSD using a high number of threads. Let's say an SSD shows 450MB/s with 4 threads. A cache may show 440MB/s with 8 threads.
>
> A practical difficulty in measuring latency is that the latency seen by an application is a sum of the device latency plus the time spent in request queue (and caching layer, when present). Increasing number of threads shows latency increase, although it's only because the requests stay in request queue for a longer duration. Latency measurement in a multithreaded environment is very challenging. Measurement of throughput is fairly straightforward.
>
>> > 
>> > As an enterprise level user I see both as important overall.  However,
>> > the biggest driving factor in wanting a cache device in front of any
>> > sort of target in my use cases is to hide latency as the number of
>> > threads reading and writing to the backing device go up.  So for me the
>> > cache is basically a tier stage where your ability to keep dirty blocks
>> > on it is determined by the specific use case.
> SSD caching will help in this case since SSD's latency remains almost constant regardless of location of data. HDD latency for sequential and random IO could vary by a factor of 5 or even much more.
>
> Throughput with caching could even be 100 times the HDD throughput when using multiple threaded non-sequential IO.
> -Amit

Thank you for the explanation.  In context your reasoning makes more
sense to me.

If I am understanding you correctly when you refer to throughput your
speaking more in terms of IOPS than what most people would think of as
referencing only bit rate.

I would expect a small increase in minimum and average latency when
adding in another layer that the blocks have to traverse.  If my minimum
and average increase by 20% on most of my workloads, that is very
acceptable as long as there is a decrease in 95th and 99th percentile
maximums.  I would hope that absolute maximum would decrease as well but
that is going to be much harder to achieve.

If I can help test and benchmark all three of these solutions please
ask.  I have allot of hardware resources available to me and perhaps I
can add value from an outsiders perspective.

Jason

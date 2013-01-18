Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3ARQXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:23:42 -0500
Received: from myspam1.stec-inc.com ([210.19.18.169]:60092 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752570Ab3ARQXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:23:40 -0500
X-ASG-Debug-ID: 1358526216-053ea90dcf1bf5e0001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: Jason Warr <jason@warr.net>
CC: "thornber@redhat.com" <thornber@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Date: Sat, 19 Jan 2013 00:12:31 +0800
Subject: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Topic: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
X-ASG-Orig-Subj: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Thread-Index: Ac31lEKNq/B9knw0S+OvXFIQFDNndwAAiwtw
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7342@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
 <20130117132620.GA2438@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
 <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net>
In-Reply-To: <50F970A3.4000403@warr.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1358526216
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120213
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Jason Warr [mailto:jason@warr.net]
> Sent: Friday, January 18, 2013 9:26 PM
> To: Amit Kale
> Cc: thornber@redhat.com; device-mapper development;
> kent.overstreet@gmail.com; Mike Snitzer; LKML; linux-
> bcache@vger.kernel.org
> Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching
> software for Linux kernel
> 
> 
> On 01/18/2013 03:08 AM, Amit Kale wrote:
> >> > Can you explain what you mean by that in a little more detail?
> > Let's say latency of a block device is 10ms for 4kB requests. With
> single threaded IO, the throughput will be 4kB/10ms = 400kB/s. If the
> device is capable of more throughput, a multithreaded IO will generate
> more throughput. So with 2 threads the throughput will be roughly
> 800kB/s. We can keep increasing the number of threads resulting in an
> approximately linear throughput. It'll saturate at the maximum capacity
> the device has. So it could saturate at perhaps at 8MB/s. Increasing
> the number of threads beyond this will not increase throughput.
> >
> > This is a simplistic computation. Throughput, latency and number of
> threads are related in a more complex relationship. Latency is still
> important, but throughput is more important.
> >
> > The way all this matters for SSD caching is, caching will typically
> show a higher latency compared to the base SSD, even for a 100% hit
> ratio. It may be possible to reach the maximum throughput achievable
> with the base SSD using a high number of threads. Let's say an SSD
> shows 450MB/s with 4 threads. A cache may show 440MB/s with 8 threads.
> >
> > A practical difficulty in measuring latency is that the latency seen
> by an application is a sum of the device latency plus the time spent in
> request queue (and caching layer, when present). Increasing number of
> threads shows latency increase, although it's only because the requests
> stay in request queue for a longer duration. Latency measurement in a
> multithreaded environment is very challenging. Measurement of
> throughput is fairly straightforward.
> >
> >> >
> >> > As an enterprise level user I see both as important overall.
> >> > However, the biggest driving factor in wanting a cache device in
> >> > front of any sort of target in my use cases is to hide latency as
> >> > the number of threads reading and writing to the backing device go
> >> > up.  So for me the cache is basically a tier stage where your
> >> > ability to keep dirty blocks on it is determined by the specific
> use case.
> > SSD caching will help in this case since SSD's latency remains almost
> constant regardless of location of data. HDD latency for sequential and
> random IO could vary by a factor of 5 or even much more.
> >
> > Throughput with caching could even be 100 times the HDD throughput
> when using multiple threaded non-sequential IO.
> > -Amit
> 
> Thank you for the explanation.  In context your reasoning makes more
> sense to me.
> 
> If I am understanding you correctly when you refer to throughput your
> speaking more in terms of IOPS than what most people would think of as
> referencing only bit rate.
> 
> I would expect a small increase in minimum and average latency when
> adding in another layer that the blocks have to traverse.  If my
> minimum and average increase by 20% on most of my workloads, that is
> very acceptable as long as there is a decrease in 95th and 99th
> percentile maximums.  I would hope that absolute maximum would decrease
> as well but that is going to be much harder to achieve.
> 
> If I can help test and benchmark all three of these solutions please
> ask.  I have allot of hardware resources available to me and perhaps I
> can add value from an outsiders perspective.

That'll be great. I have so far marked EIO's status as alpha. Will require a little more functionality testing before performance. Perhaps in a week or so.

-Amit

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.

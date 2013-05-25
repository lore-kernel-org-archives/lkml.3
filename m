Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3EYD6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 23:58:39 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:54913 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754269Ab3EYD6h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 23:58:37 -0400
X-ASG-Debug-ID: 1369454313-053ea947e8c5a00001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
From: Amit Kale <akale@stec-inc.com>
To: Jens Axboe <axboe@kernel.dk>, OS Engineering <osengineering@stec-inc.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Padmini Balasubramaniyan <padminib@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: RE: EnhanceIO(TM) caching driver features [1/3]
Thread-Topic: EnhanceIO(TM) caching driver features [1/3]
X-ASG-Orig-Subj: RE: EnhanceIO(TM) caching driver features [1/3]
Thread-Index: Ac5YX7JuBwqZqug8TSO0+2mX9HFy+QADGJuAACNg8TA=
Date: Sat, 25 May 2013 03:57:08 +0000
Message-ID: <A44CB407BBB85C498149811C52498A45088559@MYMBX3.stec-inc.ad>
References: <A44CB407BBB85C498149811C52498A450872D9@MYMBX3.stec-inc.ad>
 <20130524184727.GQ29680@kernel.dk>
In-Reply-To: <20130524184727.GQ29680@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [124.125.84.30]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1369454313
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.131947
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I by mistake dropped the weblink to demartek study while composing my email. The demartek study is published here: http://www.demartek.com/Demartek_STEC_S1120_PCIe_Evaluation_2013-02.html. It's an independent study. Here are a few numbers taken from this report. In a database comparison using transactions per second
HDD baseline (40 disks) - 2570 tps
240GB Cache - 9844 tps
480GB cache - 19758 tps
RAID5 pure SSD - 32380 tps
RAID0 pure SSD - 40467 tps

There are two types of performance comparisons, application based and IO pattern based. Application based tests measure efficiency of cache replacement algorithms. These are time consuming. Above tests were done by demartek over a period of time. I don't have performance comparisons between EnhanceIO(TM) driver, bcache and dm-cache. I'll try to get them done in-house. 

IO pattern based tests can be done quickly. However since IO pattern is fixed prior to the test, output tends to depend on whether the IO pattern suits the caching algorithm. These are relatively easy. I can definitely post this comparison.

Regarding IO error handling - that's really our USP :-). While it won't be possible to do a testing of bcache and dm-cache on our internal error test suites, I'll try to come up with a few points based on code comparison.

Thanks.
-Amit


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Jens Axboe
> Sent: Saturday, May 25, 2013 12:17 AM
> To: OS Engineering
> Cc: LKML; Padmini Balasubramaniyan; Amit Phansalkar
> Subject: Re: EnhanceIO(TM) caching driver features [1/3]
> 
> On Fri, May 24 2013, OS Engineering wrote:
> > Hi Jens and Kernel Gurus,
> 
> [snip]
> 
> Thanks for writing all of this up, but I'm afraid it misses the point
> somewhat. As stated previously, we have (now) two existing competing
> implementations in the kernel. I'm looking for justification on why
> YOUR solution is better. A writeup and documentation on error handling
> details is nice and all, but it doesn't answer the key important
> questions.
> 
> Lets say somebody sends in a patch that he/she claims improves memory
> management performance. To justify such a patch (or any patch, really),
> the maintenance burden vs performance benefit needs to be quantified.
> Such a person had better supply a set of before and after numbers, such
> that the benefit can be quantified.
> 
> It's really the same with your solution. You mention "the solution has
> been proven in independent testing, such as testing by Demartek.". I
> have no idea what this testing is, what they ran, compared with, etc.
> 
> So, to put it bluntly, I need to see some numbers. Run relevant
> workloads on EnhanceIO, bcache, dm-cache. Show why EnhanceIO is better.
> Then we can decide whether it really is the superior solution. Or,
> perhaps, it turns out there are inefficiencies in eg bcache/dm-cache
> that could be fixed up.
> 
> Usually I'm not such a stickler for including new code. But a new
> driver is different than EnhanceIO. If somebody submitted a patch to
> add a newly written driver for hw that we already have a driver for,
> that would be similar situation.
> 
> The executive summary: your writeup was good, but we need some relevant
> numbers to look at too.
> 
> --
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.

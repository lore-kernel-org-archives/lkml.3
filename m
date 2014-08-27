Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbaH0J0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:26:41 -0400
Received: from smtprelay0101.hostedemail.com ([216.40.44.101]:35474 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753310AbaH0J0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:26:39 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 05:26:39 EDT
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::,RULES_HIT:41:152:355:379:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2840:2907:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7652:7875:7903:7974:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12555:13069:13311:13357:13894:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: night14_2014d7dc51009
X-Filterd-Recvd-Size: 1960
User-Agent: K-9 Mail for Android
In-Reply-To: <8738ci9uzl.fsf@openvz.org>
References: <8738ci9uzl.fsf@openvz.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: tracing: horrible read performance on host with many CPUs
From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 27 Aug 2014 05:20:13 -0400
To: Dmitry Monakhov <dmonakhov@openvz.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <e4e7e532-ba56-410f-8a13-76757c7e5317@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use trace-cmd. It reads the per cpu files and sorts later

-- Steve

On August 27, 2014 4:50:38 AM GMT-04:00, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>
>I have tried to use tracing on host with 32cpus, but it is appeared
>that performance is horrible.
>dd if=/sys/kernel/debug/tracing/trace_pipe of=tmpfs/t3.log  bs=1M 
>0+21268 records in
>0+21267 records out
>85701248 bytes (86 MB) copied, 26.1424 s, 3.3 MB/s
>0+25706 records in
>0+25705 records out
>103600749 bytes (104 MB) copied, 31.6595 s, 3.3 MB/s
>0+59204 records in
>0+59203 records out
>238746128 bytes (239 MB) copied, 73.4347 s, 3.3 MB/s
>Since I've collected ~3Gb of data this takes a lot of time to
>simply copy from kernel to tmpfs. 
>
>AFAIU this happen due to sub-optimal sorting procedure
>__find_next_entry
>Each time it walks each cpu and pick the one with smallest timestamp.
>This can be optimized simply by fetching N-entries at the time. Are
>there any plans to implement that?
>
>BTW:What is the most convenient way fetch big data from traces?
>One of possible way is to dump per-cpu traces(20Mb/s in my case) and
>then merge files according to timestamp

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.

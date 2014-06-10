Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaFJVPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:15:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36663 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbaFJVPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:15:37 -0400
Message-ID: <5397753B.2020009@fb.com>
Date: Tue, 10 Jun 2014 15:14:35 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        "willy@linux.intel.com" <willy@linux.intel.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
References: <1402392038-5268-1-git-send-email-m@bjorling.me> <1402392038-5268-2-git-send-email-m@bjorling.me>,<alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR>
In-Reply-To: <alpine.LRH.2.03.1406101458470.4699@AMR>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_06:2014-06-10,2014-06-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406100256
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 03:10 PM, Keith Busch wrote:
> On Tue, 10 Jun 2014, Jens Axboe wrote:
>> On 06/10/2014 01:29 PM, Keith Busch wrote:
>>> I have two devices, one formatted 4k, the other 512. The 4k is used as
>>> the TEST_DEV and 512 is used as SCRATCH_DEV. I'm always hitting a BUG
>>> when
>>> unmounting the scratch dev in xfstests generic/068. The bug looks like
>>> nvme was trying to use an SGL that doesn't map correctly to a PRP.
>>
>> I'm guessing it's some of the coalescing settings, since the driver is
>> now using the generic block rq mapping.
> 
> Ok, sounds right. I mentioned in a way earlier review it doesn't look
> like a request that doesn't conform to a PRP list would get split anymore,
> and this test seems to confirm that.
> 
> Can we create something that will allow a driver to add DMA constraints to
> a request queue with the rules of a PRP list?

I haven't even looked at the rules - can you briefly outline them? From
a quick look, seems it does prp chaining for every 512 entries. But
nvme_setup_prps() looks like voodoo to an uninitiated, it could have
used a comment or two :-)



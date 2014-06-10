Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaFJQUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:20:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11651 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbaFJQUU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:20:20 -0400
From: Jens Axboe <axboe@fb.com>
To: Keith Busch <keith.busch@intel.com>
CC: =?iso-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        "willy@linux.intel.com" <willy@linux.intel.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
Thread-Topic: [PATCH v7] NVMe: conversion to blk-mq
Thread-Index: AQHPhI1k5o6fCfFYrUyl/19F7HUL0ptq8/wA//+SX2A=
Date: Tue, 10 Jun 2014 16:19:18 +0000
Message-ID: <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com>
References: <1402392038-5268-1-git-send-email-m@bjorling.me>
 <1402392038-5268-2-git-send-email-m@bjorling.me>,<alpine.LRH.2.03.1406100945250.4699@AMR>
In-Reply-To: <alpine.LRH.2.03.1406100945250.4699@AMR>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-10_05:2014-06-10,2014-06-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=8.28226376370367e-13 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406100196
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Jun 10, 2014, at 9:52 AM, Keith Busch <keith.busch@intel.com> wrote:
> 
>> On Tue, 10 Jun 2014, Matias Bjørling wrote:
>> This converts the current NVMe driver to utilize the blk-mq layer.
> 
> I'd like to run xfstests on this, but it is failing mkfs.xfs. I honestly
> don't know much about this area, but I think this may be from the recent
> chunk sectors patch causing a __bio_add_page to reject adding a new page.

Gah, yes that's a bug in the chunk patch. It must always allow a single page at any offset. I'll test and send out a fix. 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbaFIP2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:28:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16226 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbaFIP2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:28:04 -0400
Message-ID: <5395D24D.9000306@fb.com>
Date: Mon, 9 Jun 2014 09:27:09 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ming Lei <tom.leiming@gmail.com>, Matias Bj??rling <m@bjorling.me>,
        <willy@linux.intel.com>, <keith.busch@intel.com>,
        <sbradshaw@micron.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
References: <1402057225-7312-1-git-send-email-m@bjorling.me> <1402057225-7312-2-git-send-email-m@bjorling.me> <CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com> <5395BFF2.2080402@fb.com> <20140609145944.GA30626@infradead.org>
In-Reply-To: <20140609145944.GA30626@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-09_03:2014-06-09,2014-06-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=9.99200722162641e-16 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406090199
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-09 08:59, Christoph Hellwig wrote:
> On Mon, Jun 09, 2014 at 08:08:50AM -0600, Jens Axboe wrote:
>>> [  487.704074] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
>>> [  487.717881] nvme 0000:00:07.0: Aborting I/O 202 QID 1
>>> [  487.736093] end_request: I/O error, dev nvme0n1, sector 91532352
>>> [  487.747378] nvme 0000:00:07.0: completed id 0 twice on queue 0
>>>
>>>
>>> when running fio randread(libaio, iodepth:64) with more than 3 jobs.
>>>
>>> And looks no such failure when jobs is 1 or 2.
>>
>> It's a known issue, make sure you have this patch:
>>
>> https://urldefense.proofpoint.com/v1/url?u=http://git.kernel.dk/?p%3Dlinux-block.git%3Ba%3Dcommit%3Bh%3Df6be4fb4bcb396fc3b1c134b7863351972de081f&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=3JMVyziIyZtZ5cv9eWNLwQ%3D%3D%0A&m=MKK7A%2B9AnXXwtMV9YPSFEprXId0z0WLtd2JQPxnaNVc%3D%0A&s=45425e5d17390ae912457035ff081b95a7084725706ffe91166a1bdb25d8bf3d
>
> So without this patch we can get duplicate completions?  That could
> explain the issues that Robert sees with scsi-mq and hpsa..

I don't see how that would happen in general, except if the timeout
part was buggy.

-- 
Jens Axboe


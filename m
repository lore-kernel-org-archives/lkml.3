Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbaIIO01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:26:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52754 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbaIIO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:26:25 -0400
Message-ID: <540F0DDF.3010907@fb.com>
Date: Tue, 9 Sep 2014 08:25:35 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5 v2] brd: partition fixes
References: <53FDF7AD.5000709@plexistor.com> <54044759.9080103@gmail.com> <540EEE2C.1090801@plexistor.com>
In-Reply-To: <540EEE2C.1090801@plexistor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-09_05:2014-09-09,2014-09-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.1206036099054e-12 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997600857122248
 urlsuspect_oldscore=0.997600857122248 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997600857122248 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409090129
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 06:10 AM, Boaz Harrosh wrote:
> On 09/01/2014 01:15 PM, Boaz Harrosh wrote:
>> On 08/27/2014 06:22 PM, Boaz Harrosh wrote:
>>> Jens Hi
>>>
>>> What do you intend to do with these fixes? These are real bugs on devices
>>> shipped for a while now. I think they need to go into current 3.17-rcX Kernel.
>>>
>>
>> Jens hi
>>
>> I have seen that the brd patch went into rc3.
>>
>> I should insist then, that these patches go into this rc cycle ASAP.
>> For one they fix real *hard* unexpected bugs with brd that make it trash data.
>>
>> But specially because the patch to brd that just went into Kernel introduces
>> a wrong module parameter "show_part" which must be removed. If we release a Kernel
>> with it, it will be pain, we will need to deprecate it which is long and annoying
>> procedure. It is wrong because it must be always on. Pleas see below
>>
>> This patchset is based on what just went into Kernel.
>> Also on git here: git://git.open-osd.org/pmem.git brd-partitions branch
>>
>> [https://urldefense.proofpoint.com/v1/url?u=http://git.open-osd.org/gitweb.cgi?p%3Dpmem.git%3Ba%3Dshortlog%3Bh%3Drefs/heads/brd-partitions&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=3JMVyziIyZtZ5cv9eWNLwQ%3D%3D%0A&m=XOvuGmlhiuRy6LRMabkkeXBBXOBMB9BXeBpwsjyR98Y%3D%0A&s=c5919437c1a82b2bf63f9ca95ae6d96ebf2f0fbc2ed85bb6766df0add4af40b3]
>>
>> Thanks
>> Boaz
>>
> <>
>>> list of patches:
>>> [PATCH 1/5] axonram: Fix bug in direct_access
>>> [PATCH 2/5] Change direct_access calling convention
> <>
>>> [PATCH 3/5] brd: Add getgeo to block ops
> <>
>>> [PATCH 4/5] brd: Fix all partitions BUGs
>>> [PATCH 5/5] brd: Request from fdisk 4k alignment
> 
> Ping Jens?
> 
> Please tell me what you want to do with these patches. They must go into this Kernel
> cycle before brd is released with wrong user-mode visible nub
> 
> If you want you can drop the [PATCH 3/5] which is not important and can go in next
> cycle, but the others are real BUG fixes.

I will drop the 3/5 patch (do that one separately) and queue up and test.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbaJ3OPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:15:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53022 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760266AbaJ3OPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:15:21 -0400
Message-ID: <545247F4.9010000@fb.com>
Date: Thu, 30 Oct 2014 08:15:16 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>,
        Dan Williams <dan.j.williams@intel.com>
CC: "Jason B. Akers" <jason.b.akers@intel.com>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        "Karkra, Kapil" <kapil.karkra@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox> <20141029201417.GK16186@dastard> <545157DB.70304@fb.com> <20141029220905.GL16186@dastard> <CAPcyv4iiqfeWQyZpzYwASFV+7Ztjcjrp0DEq3ThOmdwgWGGJUw@mail.gmail.com> <20141030072111.GJ13323@dastard>
In-Reply-To: <20141030072111.GJ13323@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-30_06:2014-10-30,2014-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.930852144804552 urlsuspect_oldscore=0.930852144804552
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.930852144804552 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410300133
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-30 01:21, Dave Chinner wrote:
> On Wed, Oct 29, 2014 at 03:24:11PM -0700, Dan Williams wrote:
>> On Wed, Oct 29, 2014 at 3:09 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> On Wed, Oct 29, 2014 at 03:10:51PM -0600, Jens Axboe wrote:
>>>> As for the fs accessing this, the io nice fields are readily exposed
>>>> through the ->bi_rw setting. So while the above example uses ionice to
>>>> set a task io priority (that a bio will then inherit), nothing prevents
>>>> you from passing it in directly from the kernel.
>>>
>>> Right, but now the filesystem needs to provide that on a per-inode
>>> basis, not from the task structure as the task that is submitting
>>> the bio is not necesarily the task doing the read/write syscall.
>>>
>>> e.g. the write case above doesn't actually inherit the task priority
>>> at the bio level at all because the IO is being dispatched by a
>>> background flusher thread, not the ioniced task calling write(2).
>>
>> When the ioniced task calling write(2) inserts the page into the page
>> cache then the current priority is recorded in the struct page.  The
>
> It does? Can you point me to where the page cache code does this,
> because I've clearly missed something important go by in the past
> few months...

I was puzzled too, but then I realized that Dan is referring to patch 
4/5 in the series...


-- 
Jens Axboe


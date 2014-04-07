Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaDGSQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:16:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47700 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755819AbaDGSQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:16:45 -0400
Message-ID: <5342EB8A.5060607@fb.com>
Date: Mon, 7 Apr 2014 12:16:42 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: <dm-devel@redhat.com>, <mpatocka@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: block: use kmalloc alignment for bio slab
References: <1396461856-27243-1-git-send-email-snitzer@redhat.com> <20140407181550.GA30132@redhat.com>
In-Reply-To: <20140407181550.GA30132@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-07_02:2014-04-07,2014-04-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=0.000422209101481941 kscore.compositescore=0
 circleOfTrustscore=52.5391723400099 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=1
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404070158
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 12:15 PM, Mike Snitzer wrote:
> On Wed, Apr 02 2014 at  2:04pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> From: Mikulas Patocka <mpatocka@redhat.com>
>>
>> Various subsystems can ask the bio subsystem to create a bio slab cache
>> with some free space before the bio.  This free space can be used for any
>> purpose.  Device mapper uses this per-bio-data feature to place some
>> target-specific and device-mapper specific data before the bio, so that
>> the target-specific data doesn't have to be allocated separately.
>>
>> This per-bio-data mechanism is used in place of kmalloc, so we need the
>> allocated slab to have the same memory alignment as memory allocated
>> with kmalloc.
>>
>> Change bio_find_or_create_slab() so that it uses ARCH_KMALLOC_MINALIGN
>> alignment when creating the slab cache.  This is needed so that dm-crypt
>> can use per-bio-data for encryption - the crypto subsystem assumes this
>> data will have the same alignment as kmalloc'ed memory.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>
> Hey Jens,
>
> Just wanted to give you a heads up that I staged this patch in
> linux-dm.git's 'for-next', here:
> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h%3Dfor-next%26id%3Dcd433c25f43eb054f62b7b48f1d0349f65b1740c&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=3JMVyziIyZtZ5cv9eWNLwQ%3D%3D%0A&m=yu%2BvHiMLQp0QZVW7KCcxC6XDci1OzHP9ymRaDDIROdk%3D%0A&s=7ac8f47451490f80d8bacbef2487bfa43c0d7c9a1c968558010f06f92e20caca
>
> I rebased it to add this yesterday:
> Acked-by: Jens Axboe <axboe@fb.com> # via private exchange on facebook
>
> I put this in place because there is a chance I'll still be sending the
> improved dm-crypt parallelization patches to Linus for 3.15 this week.
> So having this go through linux-dm.git saves the awkward coordination
> where otherwise DM would be depending on the block tree.
>
> You OK with this?

Yeah, that's fine.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbaJ3OTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:19:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5534 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759180AbaJ3OS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:18:26 -0400
Message-ID: <54524894.8040604@fb.com>
Date: Thu, 30 Oct 2014 08:17:56 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "Jason B. Akers" <jason.b.akers@intel.com>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        "Karkra, Kapil" <kapil.karkra@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>	<yq1k33il3b3.fsf@sermon.lab.mkp.net>	<5451A3F5.9020903@fb.com>	<yq1bnoukzhe.fsf@sermon.lab.mkp.net> <CAPcyv4ggAXzWows0PayvspOX4aP9G0PmLDes+0Q+m6VXQcF9Mw@mail.gmail.com>
In-Reply-To: <CAPcyv4ggAXzWows0PayvspOX4aP9G0PmLDes+0Q+m6VXQcF9Mw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-30_06:2014-10-30,2014-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=119.615883501382
 compositescore=0.98609165920913 urlsuspect_oldscore=0.98609165920913
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410300134
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-29 22:19, Dan Williams wrote:
> I understand the desire to have per-io / per-inode xadvise()-style
> hints, but I don't see why not also include a per-pid capability?
>
> Per-pid was not "icky" for flashcache [1].  It let's you flag
> processes that should not pollute the cache, as well "cache warming"
> processes pre-loading sub-ranges of files that is awkward to do with a
> per-inode hint.  Per-pid also allows hinting on behalf of other
> otherwise cache-unaware processes.

per-pid is imho fine as well, as long as it's not the primary interface. 
I quite like how the io priority works in this regard. If the task has a 
priority set, we use that. If you pass in something else, that overrides 
the task set one.

per-pid allows you to modify how we treat applications without modifying 
the application itself. This is handy for eg streamed backup and 
similar, which is most likely why flashcache has it.

-- 
Jens Axboe


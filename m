Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaKCBYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 20:24:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54677 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbaKCBYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 20:24:32 -0500
Message-ID: <5456D944.90905@fb.com>
Date: Sun, 2 Nov 2014 18:24:20 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <akpm@linux-foundation.org>, Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 3.2 023/102] block: Fix dev_t minor allocation lifetime
References: <lsq.1414880883.370330013@decadent.org.uk>	 <54556A32.8020003@fb.com> <1414885706.27313.6.camel@decadent.org.uk>
In-Reply-To: <1414885706.27313.6.camel@decadent.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-03_01:2014-10-31,2014-11-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=32.0633239748743
 compositescore=0.928709100751446 urlsuspect_oldscore=0.928709100751446
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.928709100751446 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411030013
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-01 17:48, Ben Hutchings wrote:
> On Sat, 2014-11-01 at 17:18 -0600, Jens Axboe wrote:
>> On 2014-11-01 16:28, Ben Hutchings wrote:
>>> 3.2.64-rc1 review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Keith Busch <keith.busch@intel.com>
>>>
>>> commit 2da78092dda13f1efd26edbbf99a567776913750 upstream.
>>>
>>> Releases the dev_t minor when all references are closed to prevent
>>> another device from acquiring the same major/minor.
>>>
>>> Since the partition's release may be invoked from call_rcu's soft-irq
>>> context, the ext_dev_idr's mutex had to be replaced with a spinlock so
>>> as not so sleep.
>>>
>>> Signed-off-by: Keith Busch <keith.busch@intel.com>
>>> Signed-off-by: Jens Axboe <axboe@fb.com>
>>> [bwh: Backported to 3.2:
>>>    - Adjust filename
>>>    - idr insertion API is different, and blk_alloc_devt() is preallocating
>>>      a node in a different way]
>>
>> As I've noted for pretty much every stable branch so far, you have to
>> backport commit 46f341ffcfb5 as well, if you backport this one.
>
> I'm not caught up on reading the stable list, so I missed that.  Thanks
> for pointing it out again; I'll add it.

Thanks, it keeps biting me in the ass that I didn't get a Fixes: added 
to that patch...


-- 
Jens Axboe


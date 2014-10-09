Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbaJIVaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:30:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48990 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757557AbaJIVJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:14 -0400
Message-ID: <5436F974.6000605@fb.com>
Date: Thu, 9 Oct 2014 15:09:08 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kamal Mostafa <kamal@canonical.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <kernel-team@lists.ubuntu.com>
CC: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 3.13 026/163] block: Fix dev_t minor allocation lifetime
References: <1412888588-26755-1-git-send-email-kamal@canonical.com> <1412888588-26755-27-git-send-email-kamal@canonical.com>
In-Reply-To: <1412888588-26755-27-git-send-email-kamal@canonical.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-09_08:2014-10-09,2014-10-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.27640050073818e-06 kscore.compositescore=0
 circleOfTrustscore=25.0022134897655 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410090157
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 03:00 PM, Kamal Mostafa wrote:
> 3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

You need this one as well, like I told Greg the other day:

commit 46f341ffcfb5d8530f7d1e60f3be06cce6661b62
Author: Jens Axboe <axboe@fb.com>
Date:   Tue Sep 16 13:38:51 2014 -0600

    genhd: fix leftover might_sleep() in blk_free_devt()

    Commit 2da78092 changed the locking from a mutex to a spinlock,
    so we now longer sleep in this context. But there was a leftover
    might_sleep() in there, which now triggers since we do the final
    free from an RCU callback. Get rid of it.

    Reported-by: Pontus Fuchs <pontus.fuchs@gmail.com>
    Signed-off-by: Jens Axboe <axboe@fb.com>

-- 
Jens Axboe


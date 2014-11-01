Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaKAXS1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:18:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1655 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750785AbaKAXSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 19:18:23 -0400
Message-ID: <54556A32.8020003@fb.com>
Date: Sat, 1 Nov 2014 17:18:10 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC: <akpm@linux-foundation.org>, Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 3.2 023/102] block: Fix dev_t minor allocation lifetime
References: <lsq.1414880883.370330013@decadent.org.uk>
In-Reply-To: <lsq.1414880883.370330013@decadent.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-01_03:2014-10-31,2014-11-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=32.0633239748743
 compositescore=0.928709100751446 urlsuspect_oldscore=0.928709100751446
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.928709100751446 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411010240
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-01 16:28, Ben Hutchings wrote:
> 3.2.64-rc1 review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Keith Busch <keith.busch@intel.com>
>
> commit 2da78092dda13f1efd26edbbf99a567776913750 upstream.
>
> Releases the dev_t minor when all references are closed to prevent
> another device from acquiring the same major/minor.
>
> Since the partition's release may be invoked from call_rcu's soft-irq
> context, the ext_dev_idr's mutex had to be replaced with a spinlock so
> as not so sleep.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> Signed-off-by: Jens Axboe <axboe@fb.com>
> [bwh: Backported to 3.2:
>   - Adjust filename
>   - idr insertion API is different, and blk_alloc_devt() is preallocating
>     a node in a different way]

As I've noted for pretty much every stable branch so far, you have to 
backport commit 46f341ffcfb5 as well, if you backport this one.

-- 
Jens Axboe


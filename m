Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbbABRkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:40:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22935 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbbABRkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:40:14 -0500
Message-ID: <54A6D7F9.3090203@fb.com>
Date: Fri, 2 Jan 2015 10:40:09 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Ming Lei <ming.lei@canonical.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix checking return value of blk_mq_init_queue
References: <1420208727-9563-1-git-send-email-ming.lei@canonical.com> <54A6BEE7.3020601@fb.com> <20150102173447.GS22149@ZenIV.linux.org.uk>
In-Reply-To: <20150102173447.GS22149@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-02_07:2014-12-31,2015-01-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=7.37055184658041
 compositescore=0.98609165920913 urlsuspect_oldscore=0.98609165920913
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501020170
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2015 10:34 AM, Al Viro wrote:
> On Fri, Jan 02, 2015 at 08:53:11AM -0700, Jens Axboe wrote:
>> On 01/02/2015 07:25 AM, Ming Lei wrote:
>>> Check IS_ERR_OR_NULL(return value) instead of just return value.
>>
>> Thanks Ming, applied.
>
> Umm...  Looking at the callers, I'd suggest making it _never_ return NULL -
> it's always treates as ERR_PTR(-ENOMEM) anyway.  Then the checks would be
> just IS_ERR(...).
>
> IS_ERR_OR_NULL() is very often a sign of lousy calling conventions and
> this case is no exception...

I actually made that change when committing it:

http://git.kernel.dk/?p=linux-block.git;a=commit;h=35b489d32fcc37e8735f41aa794b24cf9d1e74f5


-- 
Jens Axboe


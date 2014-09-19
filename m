Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaISOV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:21:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7955 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754306AbaISOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:21:25 -0400
Message-ID: <541C3BD8.2070206@fb.com>
Date: Fri, 19 Sep 2014 08:21:12 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@parallels.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi-mq: fix hw queue hang caused by timeout
References: <1411055950-28657-1-git-send-email-ming.lei@canonical.com>	<20140918163549.GB3950@lst.de>	<541B105E.1030507@fb.com>	<CACVXFVP18pgz03LSwab-n2tKMAT15JmuF7Eh_O+q9TOHmhj2Qw@mail.gmail.com> <CACVXFVN1juQnXNkRvi5gHX89y-Eqr_Y7bLbOwHS-Shc5MKeHqg@mail.gmail.com>
In-Reply-To: <CACVXFVN1juQnXNkRvi5gHX89y-Eqr_Y7bLbOwHS-Shc5MKeHqg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-19_06:2014-09-19,2014-09-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.08857367564497e-13 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.994525499955221
 urlsuspect_oldscore=0.994525499955221 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.994525499955221 spamscore=0
 recipient_to_sender_domain_totalscore=1 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409190128
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 08:18 AM, Ming Lei wrote:
> On Fri, Sep 19, 2014 at 9:07 PM, Ming Lei <ming.lei@canonical.com> wrote:
>> On Fri, Sep 19, 2014 at 1:03 AM, Jens Axboe <axboe@fb.com> wrote:
>>> On 2014-09-18 10:35, Christoph Hellwig wrote:
>>>>
>>>> On Thu, Sep 18, 2014 at 11:59:10PM +0800, Ming Lei wrote:
>>>>>
>>>>> If there are two requests or more timed out, the dispatch queue
>>>>> is put into stopped state and never be recoverd, and there
>>>>> is no such problem in non-mq mode.
>>>>>
>>>>> This patch trys to recover the stopped queue when the queue
>>>>> becomes unbusy, then the following retries can move on.
>>>>>
>>>>> Basically this patch maintains same behavior for this situation
>>>>> with non-mq mode.
>>>>
>>>>
>>>> This looks somewhat similar to the issues that Doug reported, and I
>>>> remember
>>>> when he was last running into boot problems it was timeout related, too.
>>>>
>>>> As far as the implementation is concerned I think the correct fix is
>>>> to clear the BLK_MQ_S_STOPPED queue flags in blk_mq_kick_requeue_list.
>>>
>>>
>>> Since that's the kick part of the requeue, auto-starting the queue for that
>>> makes a lot of sense. I say that's the way we go.
>>
>> Yeah, that looks better.
>>
>> But it doesn't work after the simple change, and I need to
>> investigate further.
> 
> It is because of the timer miss, now it starts to work.

Excellent. I think most new issues should be fixed in for-linus for
inclusion in this round. It's much bigger than I hoped for this late in
the cycle, but lots of us have run a lot of testing, so that's not a
huge worry.

-- 
Jens Axboe


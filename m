Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaIRRED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:04:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17122 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbaIRREA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:04:00 -0400
Message-ID: <541B105E.1030507@fb.com>
Date: Thu, 18 Sep 2014 11:03:26 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
CC: James Bottomley <JBottomley@parallels.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi-mq: fix hw queue hang caused by timeout
References: <1411055950-28657-1-git-send-email-ming.lei@canonical.com> <20140918163549.GB3950@lst.de>
In-Reply-To: <20140918163549.GB3950@lst.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-18_07:2014-09-18,2014-09-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409180154
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-18 10:35, Christoph Hellwig wrote:
> On Thu, Sep 18, 2014 at 11:59:10PM +0800, Ming Lei wrote:
>> If there are two requests or more timed out, the dispatch queue
>> is put into stopped state and never be recoverd, and there
>> is no such problem in non-mq mode.
>>
>> This patch trys to recover the stopped queue when the queue
>> becomes unbusy, then the following retries can move on.
>>
>> Basically this patch maintains same behavior for this situation
>> with non-mq mode.
>
> This looks somewhat similar to the issues that Doug reported, and I remember
> when he was last running into boot problems it was timeout related, too.
>
> As far as the implementation is concerned I think the correct fix is
> to clear the BLK_MQ_S_STOPPED queue flags in blk_mq_kick_requeue_list.

Since that's the kick part of the requeue, auto-starting the queue for 
that makes a lot of sense. I say that's the way we go.

-- 
Jens Axboe


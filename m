Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbbATTaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:30:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13299 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751778AbbATTaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:30:23 -0500
Message-ID: <54BEACCA.4080800@fb.com>
Date: Tue, 20 Jan 2015 12:30:18 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, <linux-kernel@vger.kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] blk-mq: fix hctx/ctx kobject use-after-free
References: <1421722856-6346-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1421722856-6346-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-20_06:2015-01-20,2015-01-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.37667655053519e-14 kscore.compositescore=0
 circleOfTrustscore=52.1011374371407 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501200184
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 08:00 PM, Ming Lei wrote:
> The kobject memory shouldn't have been freed before the kobject
> is released because driver core can access it freely before its
> release.
>
> This patch frees hctx in its release callback. For ctx, they
> share one single per-cpu variable which is associated with
> the request queue, so free ctx in q->mq_kobj's release handler.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> (fix ctx kobjects)
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Thanks Ming, applied.

-- 
Jens Axboe


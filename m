Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaKCBTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 20:19:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15511 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbaKCBTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 20:19:43 -0500
Message-ID: <5456D7F5.10308@fb.com>
Date: Sun, 2 Nov 2014 18:18:45 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Richard Weinberger <richard@nod.at>, <hch@infradead.org>,
        <dedekind1@gmail.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at> <5456A787.5060104@free-electrons.com>
In-Reply-To: <5456A787.5060104@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-03_01:2014-10-31,2014-11-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.160988131301636 urlsuspect_oldscore=0.160988131301636
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.160988131301636 spamscore=0
 recipient_to_sender_domain_totalscore=4 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411030012
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-02 14:52, Ezequiel Garcia wrote:
> Hi Richard,
>
> On 11/02/2014 10:00 AM, Richard Weinberger wrote:
>> Convert the driver to blk-mq.
>>
>
> Maybe you can explain a bit better what's this all about?
>
> Both the commit that introduces blk-mq and the paper on it talk about
> high IOPS devices, multi-core, NUMA systems. I'm not sure this is the
> case for UBI-based devices.

The goal of blk-mq was to solve the issues around those systems, while 
at the same time provide a more modern infrastructure in general. It was 
never the intent to make blk-mq exclusive to higher end systems or 
devices, in fact quite the opposite. The goal is to slowly deprecate the 
old IO stack and switch everything (as far as we can) to blk-mq.

-- 
Jens Axboe


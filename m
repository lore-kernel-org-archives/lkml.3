Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbbAPWty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:49:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65082 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbbAPWtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:49:52 -0500
Message-ID: <54B99591.7080007@fb.com>
Date: Fri, 16 Jan 2015 15:49:53 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>, Boaz Harrosh <boaz@plexistor.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/4 v4] brd: Fix all partitions BUGs
References: <54AD5893.9040701@plexistor.com>	<54AD59DC.4020703@plexistor.com> <CA+8MBbJbKwyJJoFy2uyNvR5La3hFac-pSh8mZBV=BnNJzKQMhg@mail.gmail.com>
In-Reply-To: <CA+8MBbJbKwyJJoFy2uyNvR5La3hFac-pSh8mZBV=BnNJzKQMhg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-16_08:2015-01-16,2015-01-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.182402046397986 urlsuspect_oldscore=0.182402046397986
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.182402046397986 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501160221
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 03:32 PM, Tony Luck wrote:
> On Wed, Jan 7, 2015 at 8:07 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>> From: Boaz Harrosh <boaz@plexistor.com>
>>
>> This patch fixes up brd's partitions scheme, now enjoying all worlds.
> 
> linux-next-20150116 includes this as commit
> 937af5ecd0591e84ee54180fa97dcbe9bbe5fed6
> 
> On ia64 I'm seeing:
> ram0: unknown partition table
> ram1: unknown partition table
> ...
> ram15: unknown partition table
> 
> At first I blamed c8fa31730fc7 "brd: Request from fdisk 4k alignment" because it
> has all sorts of comments about PAGE_SIZE and 4k ... and my page size isn't
> 4k.  But, reverting that one didn't help.
> 
> reverting 937af5ecd0 does make the message go away.

Boaz, why wasn't GENHD_FL_SUPPRESS_PARTITION_INFO retained?

-- 
Jens Axboe


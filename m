Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab3JIWlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:41:11 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:56483 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab3JIWlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:41:09 -0400
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
To: Tejun Heo <tj@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
CC: Seiji Aguchi <seiji.aguchi@hds.com>,
        "majianpeng@gmail.com" <majianpeng@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] elevator: Fix a race in elevator switching and
 md device initialization
Thread-Topic: [PATCH v2 1/2] elevator: Fix a race in elevator switching and
 md device initialization
Thread-Index: AQHOpdLdNzajY7OslkaUETgfqPSrrZnSYvOAgAGDsgCAAEOzAIAZCgoA
Date: Wed, 9 Oct 2013 22:36:39 +0000
Message-ID: <CE7B51CA.7DB9%Tomoki.Sekiyama@hds.com>
In-Reply-To: <20130923201412.GA28667@mtj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <53E45E668556864E8B3491F78281CF5B@hds.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-09_07:2013-10-09,2013-10-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310090105
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


Is this patchset going to be merged into 3.12?

Thanks,
-- 
Tomoki

On 9/23/13 16:14 , "Tejun Heo" <tj@kernel.org> wrote:

>Hello,
>
>On Mon, Sep 23, 2013 at 08:11:55PM +0000, Tomoki Sekiyama wrote:
>> >Hmm... why aren't we just changing elevator_init() to grab sysfs_lock
>> >where necessary?
>> 
>> The locking cannot be moved into elevator_init() because it is called
>> from elevator_switch() path, where the request_queue's sysfs_lock is
>> already taken.
>> 
>> > It'd be more consistent with elevator_exit() that way.
>> 
>> What elevator_exit() locks is elevator_queue's sysfs_lock, not
>> request_queue's sysfs_lock. What we need here is request_queue's
>> sysfs_lock.
>
>Ah, okay.
>
> Reviewed-by: Tejun Heo <tj@kernel.org>
>
>Thanks.
>
>-- 
>tejun


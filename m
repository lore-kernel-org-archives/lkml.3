Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbaJWQaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:30:25 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60091 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaJWQaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:30:23 -0400
Message-ID: <54492D1F.3080005@kernel.dk>
Date: Thu, 23 Oct 2014 10:30:23 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] block: wrong return value
References: <1414080271-6551-1-git-send-email-sudipm.mukherjee@gmail.com> <54492840.9050704@kernel.dk> <20141023162859.GB6590@sudip-PC>
In-Reply-To: <20141023162859.GB6590@sudip-PC>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 10:28 AM, Sudip Mukherjee wrote:
> On Thu, Oct 23, 2014 at 10:09:36AM -0600, Jens Axboe wrote:
>> On 10/23/2014 10:04 AM, Sudip Mukherjee wrote:
>>> while compiling integer err was showing as a set but unused variable.
>>> elevator_init_fn can be either cfq_init_queue or deadline_init_queue
>>> or noop_init_queue.
>>> all three of these functions are returning -ENOMEM if they fail to
>>> allocate the queue.
>>> so we should actually be returning the error code rather than
>>> returning 0 always.
>>>
>>> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
>>> ---
>>>
>>> change in v2: added elevator_put
>>>
>>>  block/elevator.c | 6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/block/elevator.c b/block/elevator.c
>>> index 24c28b6..1267c2b 100644
>>> --- a/block/elevator.c
>>> +++ b/block/elevator.c
>>> @@ -184,7 +184,7 @@ static void elevator_release(struct kobject *kobj)
>>>  int elevator_init(struct request_queue *q, char *name)
>>>  {
>>>  	struct elevator_type *e = NULL;
>>> -	int err;
>>> +	int err = 0;
>>
>> Why init it to 0?
> not required actually. my initial thinking was that we are returning 0 on success or else the error code. so gave it a default value of 0.
> but elevator_init_fn is returning 0 on success , so we will get 0 even if we do not initialize it.
> should i resend after modifying it?

Yes resend it please, the assignment is meaningless as it is overwritten
later before being used.

-- 
Jens Axboe


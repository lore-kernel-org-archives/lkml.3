Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3EPCFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 22:05:47 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49430 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab3EPCFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 22:05:46 -0400
X-Spam-Score: -100.8
Message-ID: <51943EC4.60400@asianux.com>
Date: Thu, 16 May 2013 10:04:52 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: kfree issue, need check flag 'WQ_UNBOUND'
 when processing failure.
References: <519236E0.4020301@asianux.com> <20130514152046.GC6795@mtj.dyndns.org> <5192E62C.5090107@asianux.com> <20130515211116.GD26222@htj.dyndns.org>
In-Reply-To: <20130515211116.GD26222@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 05:11 AM, Tejun Heo wrote:
> On Wed, May 15, 2013 at 09:34:36AM +0800, Chen Gang wrote:
>> On 05/14/2013 11:20 PM, Tejun Heo wrote:
>>> On Tue, May 14, 2013 at 09:06:40PM +0800, Chen Gang wrote:
>>>>  err_destroy:
>>>>  	destroy_workqueue(wq);
>>>> +	if (flags & WQ_UNBOUND) {
>>>> +err_free_wq:
>>>> +		free_workqueue_attrs(wq->unbound_attrs);
>>>> +		kfree(wq);
>>>> +	}
>>>
>>> Doesn't the above make the code free wq twice on after err_destroy?
>>>
>>
>> Oh, it is my fault. I did not see the put_pwq_unlocked() in details,
>> next I should read the code carefully.
> 
> We're still leaking unbound_attrs in the failure path, right?  We can
> probably just add unconditional free_workqueue_attrs() in err_free_wq?
> 

It seems that it already done, the related patch is provided by you :
"6029a91 workqueue: add workqueue->unbound_attrs".

Please check.


Thanks.
-- 
Chen Gang

Asianux Corporation

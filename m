Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3EOBf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 21:35:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:26892 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3EOBf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 21:35:27 -0400
X-Spam-Score: -100.8
Message-ID: <5192E62C.5090107@asianux.com>
Date: Wed, 15 May 2013 09:34:36 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: kfree issue, need check flag 'WQ_UNBOUND'
 when processing failure.
References: <519236E0.4020301@asianux.com> <20130514152046.GC6795@mtj.dyndns.org>
In-Reply-To: <20130514152046.GC6795@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 11:20 PM, Tejun Heo wrote:
> On Tue, May 14, 2013 at 09:06:40PM +0800, Chen Gang wrote:
>>  err_destroy:
>>  	destroy_workqueue(wq);
>> +	if (flags & WQ_UNBOUND) {
>> +err_free_wq:
>> +		free_workqueue_attrs(wq->unbound_attrs);
>> +		kfree(wq);
>> +	}
> 
> Doesn't the above make the code free wq twice on after err_destroy?
> 

Oh, it is my fault. I did not see the put_pwq_unlocked() in details,
next I should read the code carefully.


Thanks.
-- 
Chen Gang

Asianux Corporation

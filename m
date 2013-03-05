Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3CEWk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:40:57 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:46645 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3CEWk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:40:56 -0500
Message-ID: <51367470.5040909@gmail.com>
Date: Wed, 06 Mar 2013 09:40:48 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 16/31] workqueue: introduce workqueue_attrs
References: <1362194662-2344-1-git-send-email-tj@kernel.org> <1362194662-2344-17-git-send-email-tj@kernel.org> <20130304183742.GI30413@htj.dyndns.org> <513671CF.5050705@gmail.com> <20130305223327.GA1227@htj.dyndns.org> <20130305223434.GB1227@htj.dyndns.org>
In-Reply-To: <20130305223434.GB1227@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/13 09:34, Tejun Heo wrote:
> On Tue, Mar 05, 2013 at 02:33:27PM -0800, Tejun Heo wrote:
>> Hello, Ryan.
>>
>> On Wed, Mar 06, 2013 at 09:29:35AM +1100, Ryan Mallon wrote:
>>>> @@ -148,6 +148,8 @@ struct worker_pool {
>>>>  	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
>>>>  	struct ida		worker_ida;	/* L: for worker IDs */
>>>>  
>>>> +	struct workqueue_attrs	*attrs;		/* I: worker attributes */
>>>
>>> If attrs always exists, why not just embed the struct and avoid the
>>> need to alloc/free it?
>>
>> Because then it'll need a separate init paths for embedded ones.  If
>> the field was in any way hot, I'd have embedded it but it isn't and
>> it's just less code to share the alloc path.
> 
> Ooh, right, and that cpumask_t is going away and you can't statically
> allocate cpumask_var_t, so it needs an allocation and error check from
> it anyway.

Not sure I follow. I mean drop the pointer, eg:

	struct workqueue_attr attrs;

Since, at least in this patch, struct worker_pool appears to always
alloc the attrs field. You do still of course need the cpumask_t
initialisation. Am I missing something?

~Ryan



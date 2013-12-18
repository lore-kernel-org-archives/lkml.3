Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3LRPzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:55:45 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:29320 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070Ab3LRPzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:55:44 -0500
Message-ID: <52B1C57E.7000901@akamai.com>
Date: Wed, 18 Dec 2013 10:55:42 -0500
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Andrew Jones <drjones@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 7/7] jump_label: use defined macros instead of hard-coding
 for better readability
References: <1386691433-6827-1-git-send-email-liuj97@gmail.com>	<1386691433-6827-8-git-send-email-liuj97@gmail.com> <20131213112019.751f7946@gandalf.local.home> <52AD8E10.2010904@gmail.com>
In-Reply-To: <52AD8E10.2010904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2013 06:10 AM, Jiang Liu wrote:
> On 12/14/2013 12:20 AM, Steven Rostedt wrote:
>> On Wed, 11 Dec 2013 00:03:53 +0800
>> Jiang Liu <liuj97@gmail.com> wrote:
>>
>>> Use macro JUMP_LABEL_TRUE_BRANCH instead of hard-coding for better
>>> readability.
>> Looks good, just a little nit. (see below)
>>
>>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
>>> ---
>>>  include/linux/jump_label.h | 15 ++++++++++-----
> ...
>>> @@ -123,9 +126,11 @@ extern void static_key_slow_dec(struct static_key *key);
>>>  extern void jump_label_apply_nops(struct module *mod);
>>>  
>>>  #define STATIC_KEY_INIT_TRUE ((struct static_key) \
>>> -	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
>>> +	{ .enabled = ATOMIC_INIT(1), \
>>> +	  .entries = (void *)JUMP_LABEL_TYPE_TRUE_BRANCH })
>>>  #define STATIC_KEY_INIT_FALSE ((struct static_key) \
>>> -	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
>>> +	{ .enabled = ATOMIC_INIT(0), \
>>> +	  .entries = (void *)JUMP_LABEL_TYPE_FALSE_BRANCH })
>> Can we prettify the backslashes like:
>>
>> #define STATIC_KEY_INIT_TRUE ((struct static_key)		\
>> 	{ .enabled = ATOMIC_INIT(1),				\
>> 	  .entries = (void *)JUMP_LABEL_TYPE_TRUE_BRANCH })
>> #define STATIC_KEY_INIT_FALSE ((struct static_key)		\
>> 	{ .enabled = ATOMIC_INIT(0),				\
>> 	  .entries = (void *)JUMP_LABEL_TYPE_FALSE_BRANCH })
>>
>>
>> Other than that.
>>
>> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Thanks Steve.
> Will make this change.

Works for me too, feel free to add:

Acked-by: Jason Baron <jbaron@akamai.com>

Thanks,

-Jason


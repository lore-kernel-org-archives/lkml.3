Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3LOLKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 06:10:39 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53770 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3LOLKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 06:10:37 -0500
Message-ID: <52AD8E10.2010904@gmail.com>
Date: Sun, 15 Dec 2013 19:10:08 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Andrew Jones <drjones@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v6 7/7] jump_label: use defined macros instead of hard-coding
 for better readability
References: <1386691433-6827-1-git-send-email-liuj97@gmail.com>	<1386691433-6827-8-git-send-email-liuj97@gmail.com> <20131213112019.751f7946@gandalf.local.home>
In-Reply-To: <20131213112019.751f7946@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 12:20 AM, Steven Rostedt wrote:
> On Wed, 11 Dec 2013 00:03:53 +0800
> Jiang Liu <liuj97@gmail.com> wrote:
> 
>> Use macro JUMP_LABEL_TRUE_BRANCH instead of hard-coding for better
>> readability.
> 
> Looks good, just a little nit. (see below)
> 
>>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
>> ---
>>  include/linux/jump_label.h | 15 ++++++++++-----
...
>> @@ -123,9 +126,11 @@ extern void static_key_slow_dec(struct static_key *key);
>>  extern void jump_label_apply_nops(struct module *mod);
>>  
>>  #define STATIC_KEY_INIT_TRUE ((struct static_key) \
>> -	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
>> +	{ .enabled = ATOMIC_INIT(1), \
>> +	  .entries = (void *)JUMP_LABEL_TYPE_TRUE_BRANCH })
>>  #define STATIC_KEY_INIT_FALSE ((struct static_key) \
>> -	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
>> +	{ .enabled = ATOMIC_INIT(0), \
>> +	  .entries = (void *)JUMP_LABEL_TYPE_FALSE_BRANCH })
> 
> Can we prettify the backslashes like:
> 
> #define STATIC_KEY_INIT_TRUE ((struct static_key)		\
> 	{ .enabled = ATOMIC_INIT(1),				\
> 	  .entries = (void *)JUMP_LABEL_TYPE_TRUE_BRANCH })
> #define STATIC_KEY_INIT_FALSE ((struct static_key)		\
> 	{ .enabled = ATOMIC_INIT(0),				\
> 	  .entries = (void *)JUMP_LABEL_TYPE_FALSE_BRANCH })
> 
> 
> Other than that.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
Thanks Steve.
Will make this change.

> 
> -- Steve
> 
>>  
>>  #else  /* !HAVE_JUMP_LABEL */
>>  
> 


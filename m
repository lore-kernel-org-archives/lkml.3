Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaHRCwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:52:22 -0400
Received: from mail1.windriver.com ([147.11.146.13]:55119 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaHRCwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:52:21 -0400
Message-ID: <53F16A32.50608@windriver.com>
Date: Mon, 18 Aug 2014 11:51:30 +0900
From: Sahara <keun-o.park@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, <kpark3469@gmail.com>
CC: <hpa@zytor.com>, <rafael.j.wysocki@intel.com>, <peterz@infradead.org>,
        <rusty@rustcorp.com.au>, <kirill.shutemov@linux.intel.com>,
        <oleg@redhat.com>, <prarit@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] earlyprintk: re-enable earlyprintk calling early_param
References: <1408011216-8621-1-git-send-email-kpark3469@gmail.com> <20140814133425.0677d072ff45bce8431baae1@linux-foundation.org>
In-Reply-To: <20140814133425.0677d072ff45bce8431baae1@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2014년 08월 15일 05:34, Andrew Morton 쓴 글:
> On Thu, 14 Aug 2014 19:13:36 +0900 kpark3469@gmail.com wrote:
>
>> From: Sahara <keun-o.park@windriver.com>
>>
>> Although there are many obs_kernel_param and its names are
>> earlyprintk and also EARLY_PRINTK is also enabled, we could not
>> see the early_printk output properly until now. This patch
>> considers earlycon as well as earlyprintk.
> Sorry, I just don't understand this description.
>
> What does the patch actually do?  What was the kernel behaviour without
> the patch and what is the kernel behaviour with the patch?
>
Without this patch,
- earlycon case -
if early_param("earlycon", ...) is defined and
case #1: if cmdline has "earlycon", then it satisfies the condition 
"(p->early && parameq(param, p->str))". You can see early_printk().
case #2: if cmdline has "console", then it satisfies the condition 
"strcmp(param, "console") == 0 && strcmp(p->str, "earlycon") == 0". You 
can see early_printk().

- earlyprintk case -
if early_param("earlyprintk", ...) is defined and
case #1: if cmdline has "earlyprintk", then it satisfies the condition 
"(p->early && parameq(param, p->str))". You can see early_printk().
case #2: if cmdline has "console", it does not satisfies the condition, 
because it only checks out "earlycon" only.

This patch fixes the case #2 problem of earlyprintk.

Thanks.

Best Regards,
Sahara.


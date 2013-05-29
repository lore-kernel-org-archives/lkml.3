Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934999Ab3E2CPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:15:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56807 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934981Ab3E2CO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:14:59 -0400
Message-ID: <51A5648C.3060900@zytor.com>
Date: Tue, 28 May 2013 19:14:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Fix adjust_range_size_mask calling position
References: <1369783706-27327-1-git-send-email-yinghai@kernel.org> <51A53F84.2020208@zytor.com> <CAE9FiQXrG0qZ3yJzxsOWhVtzxEY6R9g=sL7EHXZZKNj=BTjmxg@mail.gmail.com>
In-Reply-To: <CAE9FiQXrG0qZ3yJzxsOWhVtzxEY6R9g=sL7EHXZZKNj=BTjmxg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 04:43 PM, Yinghai Lu wrote:
>>
>> Sorry, I'm not sure I understand what the above paragraph is trying to say.
> 
> We merge the continuous range with same page size allow too early.
> in the case
>      [mem 0x00200000-0x3fffffff] page 2M
>      [mem 0x40000000-0x7bffffff] page 2M
> after merging them, will get
>      [mem 0x00200000-0x7bffffff] page 2M
> even we can use 1G page to map
>      [mem 0x40000000-0x7bffffff]
> 
> that will cause problem, because we map
>      [mem 0x7fe00000-0x7fffffff] page 1G
>      [mem 0x7c000000-0x7fdfffff] page 1G
> with 1G page.
> 
> so need to adjust page size at first before merge
>      [mem 0x00200000-0x3fffffff] page 2M
>      [mem 0x40000000-0x7bffffff] page 2M
> 

What I meant with that is please update the description so someone
uninitiated can follow the description, either now or in 5-10 years.

	-hpa



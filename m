Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967598Ab3E3GTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 02:19:20 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:39508 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967549Ab3E3GTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 02:19:13 -0400
Message-ID: <51A6EF57.8020507@acm.org>
Date: Thu, 30 May 2013 08:19:03 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] timer: Fix jiffies wrap behavior of round_jiffies*()
References: <519BC066.5080600@acm.org> <20130529160150.f0a498d188dc790d018200e9@linux-foundation.org>
In-Reply-To: <20130529160150.f0a498d188dc790d018200e9@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/13 01:01, Andrew Morton wrote:
> On Tue, 21 May 2013 20:43:50 +0200 Bart Van Assche <bart.vanassche@gmail.com> wrote:
>
>> Make sure that the round_jiffies*() functions return a time that is
>> in the future when the jiffies counter is about to wrap.
>
> Actually "when the jiffies counter has recently wrapped".
>
> I assume this was found by inspection?

Hello Andrew,

You are correct, this was found via source code inspection. I started 
reviewing the round_jiffies*() implementation because I was chasing a 
bug in a kernel driver using one of these functions.

>> -		return original;
>> -	return j;
>> +	return time_is_after_jiffies(j) ? j : original;
>>   }
>
> Your email client mangles patches, btw.

Sorry. Will take more care in the future.

Bart.


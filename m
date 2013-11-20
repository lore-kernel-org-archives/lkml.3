Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3KTVAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:00:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41028 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab3KTVAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:00:36 -0500
Message-ID: <528D22DB.1020208@zytor.com>
Date: Wed, 20 Nov 2013 13:00:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>	<528AF5D7.7000308@zytor.com>	<20131119184959.GE29695@two.firstfloor.org>	<528CE65B.6020300@zytor.com> <87mwkzvvck.fsf@tassilo.jf.intel.com>
In-Reply-To: <87mwkzvvck.fsf@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 09:25 AM, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>>
>> We're talking user space here, which has different requirement (COW,
>> memory protection, ...) which means it is not really the same code.  You
>> can't take a page fault while patching the kernel.
> 
> The syscall pins the page, then it calls the kernel code.
> There are no page faults during patching.
> 

But you don't need to pin anything if you just do it in userspace.
Again, it is particularly poignant for large batched operations.

	-hpa


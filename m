Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3LJQTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:19:54 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:61095 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3LJQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:19:52 -0500
MIME-Version: 1.0
In-Reply-To: <16479184.50751386647682015.JavaMail.weblogic@epv6ml09>
References: <16479184.50751386647682015.JavaMail.weblogic@epv6ml09>
Date: Tue, 10 Dec 2013 21:49:51 +0530
Message-ID: <CAPoNrttdDbwstOMa8s23oLmzOc2KcJztfgmVB0A8mCWWR0DZZQ@mail.gmail.com>
Subject: Re: [PATCH V6] ARM : unwinder : Prevent data abort due to stack overflow
From: Anurag Aggarwal <anurag19aggarwal@gmail.com>
To: Anurag Aggarwal <a.anurag@samsung.com>
Cc: Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Naveen Kumar <naveen.sel@samsung.com>,
        Narendra Meher <narendra.m1@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ashish Kalra <ashish.kalra@samsung.com>, "cpgs ." <cpgs@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        Rajat Suri <rajat.suri@samsung.com>,
        Poorva Srivastava <poorva.s@samsung.com>,
        Mohammad Irfan Ansari <mohammad.a2@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>+               if (*vsp >= (unsigned long *)ctrl->sp_high)
>>+                       return -URC_FAILURE;

I tested the same patch, by adding a printk statement in the above if condition.
The print statement I added came a few times as a part of dmesg log.

I think this proves that such corner cases are being handled by the above code

Regards
Anurag

On Tue, Dec 10, 2013 at 9:24 AM, Anurag Aggarwal <a.anurag@samsung.com> wrote:
>>Reviewed-by: Dave Martin <Dave.Martin@arm.com>
>>
>>I can confirm that the kernel "doesn't crash" with this applied, and
>>that backtracing at least partially works.  But this is not really
>>sufficient to demontrate that the now code works better than the old
>>code in corner cases (which is the point of the patch).
>>
>>Can you give details of what additional testing you have, or plan to
>>do?
>
> We saw a data abort in unwinder for one of Samsung Project, during a
> Samsung Automation test case.
> After that I created the initial the patch, and the data abort has not been
> seen till now.
>
> Is it possible for you to give an idea on what other kind of additional testing
> do you have in mind.
>
> Regads
> Anurag
>



-- 
Anurag Aggarwal

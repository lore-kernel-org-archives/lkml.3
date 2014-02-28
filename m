Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaB1Qv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:51:59 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63048 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaB1Qv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:51:58 -0500
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/2] timer: Make sure TIMER_FLAG_MASK bits are free in allocated base
From: Viresh Kumar <viresh.kumar@linaro.org>
X-Mailer: iPad Mail (11B554a)
In-Reply-To: <alpine.DEB.2.02.1402281151180.18573@ionos.tec.linutronix.de>
Date: Fri, 28 Feb 2014 22:21:50 +0530
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DD3FA92B-E07A-448E-AF48-9E470A9E3C80@linaro.org>
References: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org> <9144e10d7e854a0aa8a673332adec356d81a923c.1393576981.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1402281151180.18573@ionos.tec.linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 28-Feb-2014, at 4:22 pm, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>> On Fri, 28 Feb 2014, Viresh Kumar wrote:
>> 
>> Currently we are using two lowest bit of base for internal purpose and so they
>> both should be zero in the allocated address. The code was doing the right thing
>> before this patch came in:
>> 
>> commit c5f66e99b7cb091e3d51ae8e8156892e8feb7fa3
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Wed Aug 8 11:10:28 2012 -0700
>> 
>>    timer: Implement TIMER_IRQSAFE
>> 
>> Tejun probably forgot to update this piece of code which checks if the lowest
>> 'n' bits are zero or not and so wasn't updated according to the new flag. Lets
>> use TIMER_FLAG_MASK in the calculations here, so that this code wouldn't require
>> a change later on with another flag in.
> 
> Are you planning to introduce more flag horror? Don't go there. The
> timer_list code is about to be rewritten completely and I'm not going
> to add new features to the existing code base.

Not at all. I was just trying to understand this framework and found this
Issue.
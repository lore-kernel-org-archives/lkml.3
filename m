Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab3DAWxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:53:46 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46801 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759421Ab3DAWxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:53:43 -0400
Message-ID: <515A0E69.2040604@gmail.com>
Date: Mon, 01 Apr 2013 16:47:05 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] timekeeping: Add tracepoints for xtime changes - v2
References: <1363710477-4203-1-git-send-email-dsahern@gmail.com> <CANcMJZCJK_8r6y0MbhhgyTkk=7dMOFZO-KkeVy4MLE5PZxEZqg@mail.gmail.com> <515A0317.1070800@gmail.com> <515A072A.3080307@linaro.org>
In-Reply-To: <515A072A.3080307@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/13 4:16 PM, John Stultz wrote:
> I guess what I'm getting at is: What ABI are we creating here?  Can
> these tracepoints come and go without any consequence? Or would changing
> them in the future cause application breakage?
>
> I'm somewhat worried even trace_tod_update() is maybe too vague (again
> not that the name specifically is critical, but that the semantics we're
> specifying are clear). In other words, I think you're wanting a
> tracepoint at any time CLOCK_REALTIME is updated by anything other then
> the normal progression of time? Is that right?

yes. essentially everywhere timekeeping_update() is called except 
update_wall_time().

>
> You may want to also include the leapsecond modification in the tracing
> as well.

I thought those were covered as well. hmm... maybe not if it triggers in 
update_wall_time.

David

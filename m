Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaCLM4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:56:22 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34220 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCLM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:56:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140312090035.GM30956@twins.programming.kicks-ass.net>
References: <1394555166-22894-1-git-send-email-vincent.guittot@linaro.org> <20140312090035.GM30956@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 12 Mar 2014 13:56:00 +0100
Message-ID: <CAKfTPtCjG-=6Uqo2jPr3xZytXDkT1K1oGycTLqMCcOHoOjYSvg@mail.gmail.com>
Subject: Re: [PATCH] sched: fix: remove double calculation in fix_small_imbalance
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 March 2014 10:00, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Mar 11, 2014 at 05:26:06PM +0100, Vincent Guittot wrote:
>> The tmp value has been already calculated in:
>> scaled_busy_load_per_task =
>>               (busiest->load_per_task * SCHED_POWER_SCALE) /
>>               busiest->group_power;
>
> You created a little confusion in my brain by saying it was a fix; while
> in fact it is an optimization removing duplicate computation.

sorry for the confusion.

>
> I've changed the Subject to read:
>
>   sched: Remove double calculation in fix_small_imbalance
>

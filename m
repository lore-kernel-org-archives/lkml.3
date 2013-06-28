Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3F1R27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:28:59 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61129 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab3F1R26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:28:58 -0400
Message-ID: <51CDC7D6.9070804@gmail.com>
Date: Fri, 28 Jun 2013 11:28:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: deadlock in scheduler enabling HRTICK feature
References: <51CA0622.8010105@gmail.com> <20130625211713.GA18796@laptop.programming.kicks-ass.net> <51CA0980.8010409@gmail.com> <20130626070533.GA3601@dyad.programming.kicks-ass.net> <51CB1AE9.5090709@gmail.com> <20130627104309.GQ28407@twins.programming.kicks-ass.net> <51CCBCA9.1000200@gmail.com> <20130628090939.GD29209@dyad.programming.kicks-ass.net>
In-Reply-To: <20130628090939.GD29209@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/13 3:09 AM, Peter Zijlstra wrote:

> Yah! :-) Obviously doing a wakeup while holding scheduler locks isn't going to
> work out well. And the only reason we really need that pesky softirq nonsense
> is when we accidentally schedule a timer that's already expired; in that case
> we'll run it from sirq context.
>
> We don't care about missing events like that; there's always the actual tick
> for backup.
>
> I suppose I'd better go write a Changelog and properly submit the patch :-)
>

Thanks for the quick turnaround on the patch - and the explanation.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3HLCZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:25:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:43378 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3HLCZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:25:19 -0400
Message-ID: <52084774.7010009@huawei.com>
Date: Mon, 12 Aug 2013 10:24:52 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Karim Yaghmour <karim.yaghmour@opersys.com>
CC: <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        <mingo@elte.hu>
Subject: Re: Reading perf counters at ftrace trace boundaries
References: <5208263D.2080205@opersys.com>
In-Reply-To: <5208263D.2080205@opersys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/12 8:03, Karim Yaghmour wrote:
> 
> Wondering if there's a way for reading perf counters in the kernel. I'd
> like to read/record perf counters on ftrace function tracing
> entries/exits to provide a rundown of the value of various counters on
> function call boundaries.
> 
> [ Steven: apologies for sending you a duplicate here of what I somewhat
> already sent privately. ]
> 

If you want to base on ftrace, below two approach maybe take into use:

- register_ftrace_function/unregister_ftrace_function

- perf_event_create_kernel_counter (function event id is 1)

the first one is simplest, IMO.

You need to write your own kernel module to use these approach.

jovi.








Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3BGMNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:13:47 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:56788 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3BGMNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:13:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130206184638.GA2875@htj.dyndns.org>
References: <CAJd=RBD=yMa1-iAm_i71U+KKRNYmXDTb6yZzW5aVAGHQ+zD8Sw@mail.gmail.com>
	<20130206184638.GA2875@htj.dyndns.org>
Date: Thu, 7 Feb 2013 20:13:44 +0800
Message-ID: <CAJd=RBB+A_=nzQA+dfbt_PoxSGh1B2U+GZLQ1f8Gr6hZ5gJ1hQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] stop_machine: check work->done while handling
 enqueued works
From: Hillf Danton <dhillf@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun

On Thu, Feb 7, 2013 at 2:46 AM, Tejun Heo <tj@kernel.org> wrote:
>> @@ -279,8 +281,6 @@ repeat:
>>               preempt_disable();
>>
>>               ret = fn(arg);
>> -             if (ret)
>> -                     done->ret = ret;
>
> If this is meant as a pure cleanup, I'm not sure it's an improvement.
> You own your cpu_stop_done until you call cpu_stop_signal_done() on
> it, so I don't think there's anything wrong with the current code.
> The new code is different, not necessarily better.

The comment just above cpu_stop_signal_done()
says it is not certain that the input done is valid, so
I did this work.
Plus works enqueued through stop_one_cpu_nowait()
do carry no done.

Hillf

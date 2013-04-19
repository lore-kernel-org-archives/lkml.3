Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030422Ab3DSN3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:29:23 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:34800 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030254Ab3DSN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:29:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAFTL4hx+N9vx-k8FXQcwK_AaAHfXPEKrYSc8e6q2wuYhLVZ_bw@mail.gmail.com>
References: <1366220466.2855.14.camel@Wailaba2>
	<CAFTL4hx+N9vx-k8FXQcwK_AaAHfXPEKrYSc8e6q2wuYhLVZ_bw@mail.gmail.com>
Date: Fri, 19 Apr 2013 15:29:20 +0200
Message-ID: <CAFTL4hy0+W1bA+_BL72XdsxTjqtD6Mx+iDabaRgwS2U6LP8wYA@mail.gmail.com>
Subject: Re: [PATCH] Remove spurious cputimer restart and eliminate its drift
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Olivier Langlois <olivier@trillion01.com>
Cc: tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/19 Frederic Weisbecker <fweisbec@gmail.com>:
>>         if (!task_cputime_zero(&tsk->cputime_expires)) {
>>                 struct task_cputime task_sample = {
>> -                       .utime = utime,
>> -                       .stime = stime,
>>                         .sum_exec_runtime = tsk->se.sum_exec_runtime
>>                 };
>> +               task_cputime(tsk, &task_sample.utime, &task_sample.stime);
>
> That too needs to be in another patch. It's a bug that concerns full
> dynticks cputime accounting :)

Oops, misread, it's just moving the function, I thought it was
missing. Nevermind.

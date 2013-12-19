Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3LSVrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:47:14 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:63165 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3LSVrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:47:12 -0500
MIME-Version: 1.0
In-Reply-To: <20131219155034.661090897@linux.com>
References: <20131219155015.443763038@linux.com>
	<20131219155034.661090897@linux.com>
Date: Fri, 20 Dec 2013 01:47:11 +0400
Message-ID: <CAMo8BfJY0rGLyeOwjmrzRw4h2AedF33D3iPXDe+umHDXt5=nQw@mail.gmail.com>
Subject: Re: [PATCH 37/40] alpha: Replace __get_cpu_var
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 19, 2013 at 7:50 PM, Christoph Lameter <cl@linux.com> wrote:

[...]

> 5. Assignment to a per cpu variable
>
>         DEFINE_PER_CPU(int, y)
>         __get_cpu_var(y) = x;
>
>    Converts to
>
>         this_cpu_write(y, x);

Doesn't it actually convert to __this_cpu_write(y, x); as there were
no atomicity in the original assignment?

-- 
Thanks.
-- Max

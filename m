Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936879Ab3DJP27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:28:59 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:45478 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932799Ab3DJP25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130410125111.GA12923@gmail.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
	<20130326140147.GB2029@redhat.com>
	<CAFTL4hyJxwh056=bTsSFcpZ7QLRsvsGbni=ueUHE6c1n8dmQ7Q@mail.gmail.com>
	<20130410125111.GA12923@gmail.com>
Date: Wed, 10 Apr 2013 17:28:55 +0200
Message-ID: <CAFTL4hxsTMZhNqC9jkrc5L3zEr-KFhxvwHqk+q=0zRn6wraWSg@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        hpa@zytor.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/10 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Of course 128 bits ops are very expensive, so to help you evaluating the
>> situation, this is going to happen on every call to task_cputime_adjusted() and
>> thread_group_adjusted(), namely:
>
> It's really only expensive for divisions. Addition and multiplication should be
> straightforward and relatively low overhead, especially on 64-bit platforms.

Ok, well we still have one division in the scaling path. I'm mostly
worried about the thread group exit that makes use of it through
threadgroup_cputime_adjusted(). Not sure if we can avoid that.

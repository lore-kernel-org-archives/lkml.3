Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3FJUSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:18:40 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:53627 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3FJUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130610183300.GA14379@redhat.com>
References: <20130610183300.GA14379@redhat.com>
Date: Mon, 10 Jun 2013 13:18:39 -0700
X-Google-Sender-Auth: 1PHHJJWKKCdBpkx7CSBLqvbmLvs
Message-ID: <CANcMJZDoSMGGSaohRJXwpVcxwxZPL=zmuWeviyiQ7nZuf6Ynfg@mail.gmail.com>
Subject: Re: [PATCH 0/3] de_thread() should update ->real_start_time
From: John Stultz <john.stultz@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tomas Smetana <tsmetana@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> 1/3 is the obvious bugfix, 2 and 3 are minor cleanups
>
> I am wondering, can't we kill task->real_start_time? What if we
> simply change copy_process
>
>         -       do_posix_clock_monotonic_gettime(&p->start_time);
>         +       get_monotonic_boottime(&p->start_time);


An additional thought: task_struct covers quite a bit of stuff, so I
don't know if this would be too useful, but we could further change
start_time to be a ktime_t, allowing possible additional space savings
in the task_struct on 64bit systems.

thanks
-john

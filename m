Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbaLBTuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:50:02 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:45463 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaLBTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:49:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141202120430.71979060@gandalf.local.home>
References: <20141202120430.71979060@gandalf.local.home>
Date: Tue, 2 Dec 2014 11:49:58 -0800
Message-ID: <CAMEtUuwejSGZSMyncPo9GRvy7vnC8Wam-dOdHU+iO0cJkRDeTg@mail.gmail.com>
Subject: Re: [PATCH] tracing: Add NOT to filtering logic
From: Alexei Starovoitov <ast@plumgrid.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 9:04 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>                                                                         \
> -       return match;                                                   \
> +       return match == !pred->not;                                     \

are you sure this one works for !(var & 2) ?
'not' is either 0 or 1, so it works for other macro:
(val == *addr) ^ pred->not

whereas here 'match' is 'int' and
match = (*addr & val)
will not be 0 or 1...

the patch is small, but delicate...
In such cases I trust tests more than code review ;)
Could you add few tests for this to
CONFIG_FTRACE_STARTUP_TEST
part of the file ?

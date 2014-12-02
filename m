Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbaLBUpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:45:00 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57366 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaLBUo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141202153548.1ce7177e@gandalf.local.home>
References: <20141202120430.71979060@gandalf.local.home>
	<CAMEtUuwejSGZSMyncPo9GRvy7vnC8Wam-dOdHU+iO0cJkRDeTg@mail.gmail.com>
	<20141202153548.1ce7177e@gandalf.local.home>
Date: Tue, 2 Dec 2014 12:44:58 -0800
Message-ID: <CAMEtUuxN_GM+dbuT8Z7wc4_vAbCBOvx+uY+5jZP25Qv7hzQ7ag@mail.gmail.com>
Subject: Re: [PATCH v2] tracing: Add NOT to filtering logic
From: Alexei Starovoitov <ast@plumgrid.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 12:35 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Ted noticed that he could not filter on an event for a bit being cleared.
> That's because the filtering logic only tests event fields with a limited
> number of comparisons which, for bit logic, only include "&", which can
> test if a bit is set, but there's no good way to see if a bit is clear.
>
> This adds a way to do: !(field & 2048)
>
> Which returns true if the bit is not set, and false otherwise.
>
> Note, currently !(field1 == 10 && field2 == 15) is not supported.
> That is, the 'not' only works for direct comparisons, not for the
> AND and OR logic.
>
> Link: http://lkml.kernel.org/r/20141202021912.GA29096@thunk.org
> Link: http://lkml.kernel.org/r/20141202120430.71979060@gandalf.local.home
>
> Suggested-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

looks good to me.
Acked-by: Alexei Starovoitov <ast@plumgrid.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaI3QlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaI3QlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:41:01 -0400
Date: Tue, 30 Sep 2014 12:40:47 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: pipe/page fault oddness.
Message-ID: <20140930164047.GA18354@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Michel Lespinasse <walken@google.com>
References: <20140930033327.GA14558@redhat.com>
 <CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
 <20140930043309.GA16196@redhat.com>
 <CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
 <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
 <20140930160510.GA15903@redhat.com>
 <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
 <20140930162201.GC15903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930162201.GC15903@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:22:01PM -0400, Dave Jones wrote:
 
 > [<ffffffff91167913>] ? trace_graph_entry+0x123/0x250
 > [<ffffffff9115b7ce>] ? trace_buffer_lock_reserve+0x1e/0x60
 > [<ffffffff911c3c67>] ? handle_mm_fault+0x3a7/0xcd0
 > [<ffffffff910ce68d>] ? trace_hardirqs_on+0xd/0x10
 > [<ffffffff911678f8>] ? trace_graph_entry+0x108/0x250
 > [<ffffffff91042d14>] ? __do_page_fault+0x234/0x600
 > [<ffffffff9103ad23>] ? prepare_ftrace_return+0x73/0xe0
 > [<ffffffff910ca040>] ? down_write_nested+0xc0/0xc0
 > [<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
 > [<ffffffff91042d14>] ? __do_page_fault+0x234/0x600
 > [<ffffffff9103ad23>] ? prepare_ftrace_return+0x73/0xe0
 > [<ffffffff91826b3a>] ? ftrace_graph_caller+0x5a/0x85
 > [<ffffffff913a5ebe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 > [<ffffffff9118eda7>] ? context_tracking_user_exit+0x67/0x1b0
 > [<ffffffff910430fe>] ? do_page_fault+0x1e/0x70
 > [<ffffffff913a5efd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 > [<ffffffff911bd7e3>] ? copy_page_to_iter+0x3b3/0x500
 > [<ffffffff9120eddf>] ? pipe_read+0xdf/0x330
 > [<ffffffff9120ed00>] ? pipe_write+0x490/0x490
 > [<ffffffff912051a0>] ? do_sync_readv_writev+0xa0/0xa0
 > [<ffffffff912053b8>] ? do_iter_readv_writev+0x78/0xc0
 > [<ffffffff91206bbe>] ? do_readv_writev+0xce/0x280
 > [<ffffffff9120ed00>] ? pipe_write+0x490/0x490
 > [<ffffffff910cbbf6>] ? lock_release_holdtime.part.29+0xe6/0x160
 > [<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
 > [<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
 > [<ffffffff910ac8ab>] ? preempt_count_sub+0x6b/0xf0
 > [<ffffffff91206da9>] ? vfs_readv+0x39/0x50
 > [<ffffffff91206e6c>] ? SyS_readv+0x5c/0x100
 > [<ffffffff918249e4>] ? tracesys+0xdd/0xe2
 > 
 > That second one is odd, because I had disabled all the function tracing
 > before doing the sysrq-t, so still seeing all the ftrace stuff on the
 > stack suprised me.

ah, echo 0 > tracing_on isn't enough, I had to 0 out set_ftrace_pid too.
Never mind.  Subsequent traces all looking the same, minus the tracing
junk though.

Is there some way I can figure out what address it's faulting on ?
I wonder if that might give some clues.

	Dave


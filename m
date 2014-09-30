Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaI3Qqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:46:47 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37243 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaI3Qqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:46:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140930164047.GA18354@redhat.com>
References: <20140930033327.GA14558@redhat.com>
	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
	<20140930043309.GA16196@redhat.com>
	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
	<20140930160510.GA15903@redhat.com>
	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
	<20140930162201.GC15903@redhat.com>
	<20140930164047.GA18354@redhat.com>
Date: Tue, 30 Sep 2014 09:46:45 -0700
X-Google-Sender-Auth: 5x-mEZerQi8lJYz7YhAi9IHobQE
Message-ID: <CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>
Subject: Re: pipe/page fault oddness.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 9:40 AM, Dave Jones <davej@redhat.com> wrote:
>
> ah, echo 0 > tracing_on isn't enough, I had to 0 out set_ftrace_pid too.
> Never mind.  Subsequent traces all looking the same, minus the tracing
> junk though.

Yeah, looks like that copy_page_to_iter+0x3b3 is always there.

> Is there some way I can figure out what address it's faulting on ?
> I wonder if that might give some clues.

Could be useful. There's a trace_page_fault_kernel() entry that should
give it to you, along with error code.

            Linus

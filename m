Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaAWRPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:15:41 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:55455 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaAWRPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:15:39 -0500
MIME-Version: 1.0
In-Reply-To: <52E14D67.4000202@hp.com>
References: <1390426438-31252-1-git-send-email-Waiman.Long@hp.com>
	<1390426438-31252-2-git-send-email-Waiman.Long@hp.com>
	<20140123100751.GS30183@twins.programming.kicks-ass.net>
	<52E14D67.4000202@hp.com>
Date: Thu, 23 Jan 2014 09:15:38 -0800
X-Google-Sender-Auth: DHfwhUOy8p87kL6q0YJM5iOvtX4
Message-ID: <CA+55aFzhx6K9A62ve6E5X4juvNPewED_g1nWwq+-EY0fd0A-0g@mail.gmail.com>
Subject: Re: [PATCH v10 1/4] qrwlock: A queue read/write lock implementation
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 9:12 AM, Waiman Long <waiman.long@hp.com> wrote:
>
> I thought that all atomic RMW instructions are memory barrier.

On x86 they are. Not necessarily elsewhere.

> If they are not, what kind of barrier should be added?

smp_mb__before_atomic_xyz() and smp_mb__after_atomic_xyz() will do it,
and are no-op (well, barriers - I don't think it matters) on x86.

            Linus

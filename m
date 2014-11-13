Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522AbaKMXT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:19:56 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:51459 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920AbaKMXTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:19:54 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1415917623.git.luto@amacapital.net>
References: <cover.1415917623.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Nov 2014 15:19:32 -0800
Message-ID: <CALCETrWrQPfLzMVRAtAVYrtn=H46Wo0At1adpEyd-z=GADTqvQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Handle IST interrupts from userspace on the normal stack
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 2:31 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> We currently run IST interrupt handlers on the IST stack.  Changing
> it may simplify a few things.  See patch 2 for details.
>
> Patch 1 is a fix for a not-quite-bug in uprobes that Oleg noticed
> that would be exposed by patch 2.
>
> Andy Lutomirski (2):
>   x86, entry: Switch stacks on a paranoid entry from userspace
>   uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
>

I reversed the order of the patches -- oops.  If I send v3, I'll fix that.

--Andy

>  Documentation/x86/entry_64.txt         | 18 +++++---
>  Documentation/x86/x86_64/kernel-stacks |  8 ++--
>  arch/x86/include/asm/thread_info.h     |  2 +-
>  arch/x86/kernel/entry_64.S             | 82 +++++++++++++++++-----------------
>  arch/x86/kernel/traps.c                | 23 +++-------
>  kernel/events/uprobes.c                |  1 -
>  6 files changed, 65 insertions(+), 69 deletions(-)
>
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

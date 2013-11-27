Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab3K0WV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:21:26 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:44445 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab3K0WVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:21:22 -0500
MIME-Version: 1.0
In-Reply-To: <52966C0A.7070201@zytor.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
 <5294F10C.8060901@amacapital.net> <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
 <52964EC7.9000504@zytor.com> <52966C0A.7070201@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 27 Nov 2013 14:21:01 -0800
Message-ID: <CALCETrWZxm=5gHRwdPn-VJP+gFdn981rJsmnVcCEqF=YrkJz3g@mail.gmail.com>
Subject: Re: [PATCH] Add a text_poke syscall v2
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 2:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> For the record, this is the entire patch necessary to do the
> sync_cores() system call -- and no potential interactions with security
> frameworks or whatnot, simply because no security-sensitive operations
> are performed of any kind.
>
> Comments/opinions appreciated.

Presumably, if this were done, it should be merged with the
sys_membarrier work.  Maybe there should be a syscall for executing
some kind of barrier on all cpus that might be looking at the current
mm (and, eventually, something for MAP_SHARED as well if anyone
cares).

A benefit of the explicit text_poke approach is that it can
potentially get MAP_SHARED patching right.  I don't know if anyone
would ever want to do that, though.

--Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaHNVUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:20:09 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:59522 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaHNVUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <1407916658-8731-18-git-send-email-ast@plumgrid.com>
References: <1407916658-8731-1-git-send-email-ast@plumgrid.com>
	<1407916658-8731-18-git-send-email-ast@plumgrid.com>
Date: Thu, 14 Aug 2014 14:20:05 -0700
Message-ID: <CAE40pdf0pNYyazjpdkzxNJi7iC4LOOr_XEu078OUqP_uoCXnHg@mail.gmail.com>
Subject: Re: [PATCH RFC v4 net-next 17/26] tracing: allow eBPF programs to be
 attached to events
From: Brendan Gregg <brendan.d.gregg@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 12:57 AM, Alexei Starovoitov <ast@plumgrid.com> wrote:
[...]
> +/* For tracing filters save first six arguments of tracepoint events.
> + * On 64-bit architectures argN fields will match one to one to arguments passed
> + * to tracepoint events.
> + * On 32-bit architectures u64 arguments to events will be seen into two
> + * consecutive argN, argN+1 fields. Pointers, u32, u16, u8, bool types will
> + * match one to one
> + */
> +struct bpf_context {
> +       unsigned long arg1;
> +       unsigned long arg2;
> +       unsigned long arg3;
> +       unsigned long arg4;
> +       unsigned long arg5;
> +       unsigned long arg6;
> +       unsigned long ret;
> +};

While this works, the argN+1 shift for 32-bit is a gotcha to learn.
Lets say arg1 was 64-bit, and my program only examined arg2. I'd need
two programs, one for 64-bit (using arg2) and 32-bit (arg3). If there
was a way not to shift arguments, I could have one program for both.
Eg, additional arg1hi, arg2hi, ... for the higher order u32s.

Brendan

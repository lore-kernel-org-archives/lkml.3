Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaF1G0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:26:05 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:48527 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaF1G0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:26:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuzWs+MbSOGGD-Rc01DHKASa4GxbHdtCrSCLit4cUM35mA@mail.gmail.com>
References: <1403913966-4927-1-git-send-email-ast@plumgrid.com>
 <1403913966-4927-4-git-send-email-ast@plumgrid.com> <CALCETrV3WLBmHewCZgfhCkjODWfq_byRg6sF7HpqZ6n9BVMBVQ@mail.gmail.com>
 <CAMEtUuzWs+MbSOGGD-Rc01DHKASa4GxbHdtCrSCLit4cUM35mA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 27 Jun 2014 23:25:39 -0700
Message-ID: <CALCETrWy6=dzTycy-ckiMR92+nQeqAWp_Hw=hi__VSzVWZ43Ag@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 03/14] bpf: introduce syscall(BPF, ...) and
 BPF maps
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 10:55 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Fri, Jun 27, 2014 at 5:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Fri, Jun 27, 2014 at 5:05 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>> BPF syscall is a demux for different BPF releated commands.
>>>
>>> 'maps' is a generic storage of different types for sharing data between kernel
>>> and userspace.
>>>
>>> The maps can be created/deleted from user space via BPF syscall:
>>> - create a map with given id, type and attributes
>>>   map_id = bpf_map_create(int map_id, map_type, struct nlattr *attr, int len)
>>>   returns positive map id or negative error
>>>
>>> - delete map with given map id
>>>   err = bpf_map_delete(int map_id)
>>>   returns zero or negative error
>>
>> What's the scope of "id"?  How is it secured?
>
> the map and program id space is global and it's cap_sys_admin only.
> There is no pressing need to do it with per-user limits.
> So the whole thing is root only for now.
>

Hmm.  This may be unpleasant if you ever want to support non-root or
namespaced operation.

How hard would it be to give these things fds?

> Since I got your attention please review the most interesting
> verifier bits (patch 08/14) ;)

Will do.  Or at least I'll try :)

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC

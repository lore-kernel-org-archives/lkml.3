Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaIKUfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:35:34 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54472 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaIKUfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:35:32 -0400
MIME-Version: 1.0
In-Reply-To: <5411FDE1.3060302@redhat.com>
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com>
	<CALCETrVBb_uQZpodv67XSTGVU40y6+9Ktw=3zAJgGV2mNJ=_0A@mail.gmail.com>
	<CAMEtUuyY0L2=tz5mSvQqR_=_oN18nA6V9fdbR8OiYTPbQth8AQ@mail.gmail.com>
	<5411FDE1.3060302@redhat.com>
Date: Thu, 11 Sep 2014 13:35:31 -0700
Message-ID: <CAMEtUuyTfRwZi1-yOyrAOkubWLDLC6YZXUq8OFpqXpHPjKRYhw@mail.gmail.com>
Subject: Re: [PATCH v11 net-next 00/12] eBPF syscall, verifier, testsuite
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:54 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 09/10/2014 10:21 PM, Alexei Starovoitov wrote:
> ...
>>>>
>>>>                char bpf_log_buf[LOG_BUF_SIZE];
>>>
>>>
>>> What happens if the size isn't LOG_BUF_SIZE?
>>
>>
>> would do you mean?
>> LOG_BUF_SIZE is just a user defined macro.
>> Can be anything.
>
> I believe, Andy means, what would happen if log_level > 0 but
> the log_size is not big enough so that the human-readable error
> text string from the verifier will fit into it? I presume that
> will be truncated then ... hm.

Correct. It will be truncated and ENOSPC returned from syscall.
Just noticed that I didn't mention that in the manpage... will do.

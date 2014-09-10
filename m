Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaIJRco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:32:44 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42416 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaIJRcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <541013CE.6020307@redhat.com>
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com>
	<541013CE.6020307@redhat.com>
Date: Wed, 10 Sep 2014 10:32:40 -0700
Message-ID: <CAMEtUuwrHX4ENK9cZ0C+XVB=wkMz1=wLphX_GVLvd8pyJKMXeQ@mail.gmail.com>
Subject: Re: [PATCH v11 net-next 00/12] eBPF syscall, verifier, testsuite
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 2:03 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
>>             struct { /* anonymous struct used by BPF_PROG_LOAD command */
>>                 enum bpf_prog_type    prog_type;
>>                 __u32                 insn_cnt;
>>                 const struct bpf_insn *insns;
>>                 const char            *license;
>>                 __u32                 log_level; /* verbosity level of
>> eBPF verifier */
>>                 __u32                 log_size;  /* size of user buffer */
>>                 void                  *log_buf;  /* user supplied buffer
>> */
>
>
> What is log buffer? Would that mean the verifier will return an error
> string if the program will not pass it, or if not, what other data?
> I think the man page is missing how to examine the returned verifier
> log buffer data.

yes. it's an error log (as text string for humans) from verifier.
It is briefly explained in the man page:
       EACCES For BPF_PROG_LOAD, though program has valid instructions, it was
              rejected, since it was deemed unsafe (may access disallowed mem-
              ory region or  uninitialized  stack/register  or  function  con-
              straints don't match actual types or misaligned access). In such
              case it is recommended to call bpf() again with  log_level  =  1
              and examine log_buf for specific reason provided by verifier.
and there is a whole section about it in
Documentation/networking/filter.txt
called "Understanding eBPF verifier messages".

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaIKTsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbaIKTsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:48:04 -0400
Message-ID: <5411FC42.3070505@redhat.com>
Date: Thu, 11 Sep 2014 21:47:14 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
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
Subject: Re: [PATCH v11 net-next 00/12] eBPF syscall, verifier, testsuite
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com> <541013CE.6020307@redhat.com> <CAMEtUuwrHX4ENK9cZ0C+XVB=wkMz1=wLphX_GVLvd8pyJKMXeQ@mail.gmail.com>
In-Reply-To: <CAMEtUuwrHX4ENK9cZ0C+XVB=wkMz1=wLphX_GVLvd8pyJKMXeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 07:32 PM, Alexei Starovoitov wrote:
> On Wed, Sep 10, 2014 at 2:03 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
>>>              struct { /* anonymous struct used by BPF_PROG_LOAD command */
>>>                  enum bpf_prog_type    prog_type;
>>>                  __u32                 insn_cnt;
>>>                  const struct bpf_insn *insns;
>>>                  const char            *license;
>>>                  __u32                 log_level; /* verbosity level of
>>> eBPF verifier */
>>>                  __u32                 log_size;  /* size of user buffer */
>>>                  void                  *log_buf;  /* user supplied buffer
>>> */
>>
>>
>> What is log buffer? Would that mean the verifier will return an error
>> string if the program will not pass it, or if not, what other data?
>> I think the man page is missing how to examine the returned verifier
>> log buffer data.
>
> yes. it's an error log (as text string for humans) from verifier.

I was confused due to the void pointer. But that also means that the text
string becomes part of the ABI; aren't eBPF specific error codes (perhaps
a tuple of [line + error code]), though ugly as well, but perhaps the better
solution to this [which user space can then map to an actual string]?

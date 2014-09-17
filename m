Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaIQHQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaIQHQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:16:50 -0400
Message-ID: <54193542.6080101@redhat.com>
Date: Wed, 17 Sep 2014 09:16:18 +0200
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
Subject: Re: [PATCH v11 net-next 12/12] bpf: mini eBPF library, test stubs
 and verifier testsuite
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com> <1410325808-3657-13-git-send-email-ast@plumgrid.com> <54103776.3080706@redhat.com> <CAMEtUuzEQu30WiYprRcDBogJxxrDeNhvn=kF+z8cVvhR-vjTQg@mail.gmail.com>
In-Reply-To: <CAMEtUuzEQu30WiYprRcDBogJxxrDeNhvn=kF+z8cVvhR-vjTQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 08:08 PM, Alexei Starovoitov wrote:
> On Wed, Sep 10, 2014 at 4:35 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
>>
>> Since we already have an extensive BPF test suite, that is, lib/test_bpf.c,
>> which currently also does sanity checks for the classic BPF verifier, is
>> there a reason these verifier test cases cannot be extended/integrated there
>> as well but have to go to kernel/bpf/test_stub.c resp.
>> samples/bpf/test_verifier.c ?
>> I don't like that we put testing code into kernel/bpf/ whereas we already
>> have a BPF test infrastructure in the kernel elsewhere.
>
> yes. there is a reason. Verifier needs to be tested from user space,
> since it works on fds. Process local map_fd are part of the eBPF
> programs. Therefore one is testing things from kernel and
> another from userspace. We definitely need both.
> Currently there is no use case to call verifier from inside
> the kernel. I'm not sure there will be one. Verifier's main
> purpose is to check user supplied programs and provide
> humans an understandable error messages of what
> is 'unsafe' in particular program.
> Eventually we will integrate this verifier messages with
> program compilation. Like, the user would write a program
> in C then invoke a wrapper of compiler and verifier, which
> will point to lines in C code which are doing something
> wrong like loops or out of bounds access. Currently verifier
> complains about particular 'unsafe' instruction, but
> humans have hard time correlating asm to C.

That actually still doesn't answer my question why the test stub
cannot live in lib/test_bpf where we have our actual testing
framework for eBPF/BPF, also since you exactly only build test_stub.c
when TEST_BPF is enabled which is the Kconfig for lib/test_bpf.

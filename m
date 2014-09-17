Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbaIQWAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:00:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbaIQWAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:00:33 -0400
Message-ID: <541A045E.3030206@redhat.com>
Date: Wed, 17 Sep 2014 23:59:58 +0200
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
References: <1410325808-3657-1-git-send-email-ast@plumgrid.com> <1410325808-3657-13-git-send-email-ast@plumgrid.com> <54103776.3080706@redhat.com> <CAMEtUuzEQu30WiYprRcDBogJxxrDeNhvn=kF+z8cVvhR-vjTQg@mail.gmail.com> <54193542.6080101@redhat.com> <CAMEtUuzaCEX9RKDBMnQBZSHdTjjidp81myfSVVi4qQqtSGgtmw@mail.gmail.com>
In-Reply-To: <CAMEtUuzaCEX9RKDBMnQBZSHdTjjidp81myfSVVi4qQqtSGgtmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 06:17 PM, Alexei Starovoitov wrote:
> On Wed, Sep 17, 2014 at 12:16 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
>>
>> That actually still doesn't answer my question why the test stub
>> cannot live in lib/test_bpf where we have our actual testing
>> framework for eBPF/BPF, also since you exactly only build test_stub.c
>> when TEST_BPF is enabled which is the Kconfig for lib/test_bpf.
>
> multiple reasons:
> 1.
> lib/test_bpf.c is a module, whereas test_stub.c is kernel builtin.
>
> 2.
> I wasn't sure that reusing CONFIG_TEST_BPF for this
> purpose was a good idea. May be it's better to introduce
> CONFIG_BPF_VERIFIER_TEST_STUBS or something.
>
> 3.
> kernel/bpf/test_stubs.c can be removed once real tracing
> or socket use case is in.

Yes, please, lets go for point 3 at the very least.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaIFQE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 12:04:27 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37114 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaIFQEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 12:04:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140906141051.GA4245@salvia>
References: <1409894238-9055-1-git-send-email-ast@plumgrid.com>
	<1409894238-9055-3-git-send-email-ast@plumgrid.com>
	<20140906141051.GA4245@salvia>
Date: Sat, 6 Sep 2014 09:04:23 -0700
Message-ID: <CAMEtUuxPynQ4wdWDgCU+9_3_GRYn8oA4f-emcF+mqiQdLsqEWg@mail.gmail.com>
Subject: Re: [PATCH v10 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
From: Alexei Starovoitov <ast@plumgrid.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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

On Sat, Sep 6, 2014 at 7:10 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Sep 04, 2014 at 10:17:18PM -0700, Alexei Starovoitov wrote:
>> allow user space to generate eBPF programs
>>
>> uapi/linux/bpf.h: eBPF instruction set definition
>>
>> linux/filter.h: the rest
>>
>> This patch only moves macro definitions, but practically it freezes existing
>> eBPF instruction set, though new instructions can still be added in the future.
>>
>> These eBPF definitions cannot go into uapi/linux/filter.h, since the names
>> may conflict with existing applications.
>>
>> Full eBPF ISA description is in Documentation/networking/filter.txt
>
> I think you need to have at least one single interface using this
> before you can expose it to userspace. So this should come in the
> small batch that introduces the first interface of your ebpf code in
> userspace. AFAIK, this has been the policy so far.

That's what I've been doing over the last year.
My first eBPF patch was in Sep of 2013!
since then I've been only tweaking and massaging it.
Nothing fundamentally changed.
Last few month I've been posting these series with not only
first user, but with multiple. Many examples, test cases and so on.
The series became big and Dave asked to split them.
Please see the cover letter. These two patches is stage I.
More examples and use cases in stage II, stage III, stage IV, etc
All these patches are ready. I'm only submitting them one at
a time to make review easier.
Please see them in my tree if you interested.

Thanks

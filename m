Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbaIRSTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbaIRSTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:19:19 -0400
Message-ID: <541B1624.80302@redhat.com>
Date: Thu, 18 Sep 2014 19:28:04 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 net-next 07/11] bpf: verifier (add ability to receive
 verification log)
References: <1410914370-29883-1-git-send-email-ast@plumgrid.com> <1410914370-29883-8-git-send-email-ast@plumgrid.com> <54192F66.8020200@redhat.com> <CAMEtUuxK68ZoJ-izjLoygv0f+rLtPmMLUUq1=BJ+_ZBGfynkdA@mail.gmail.com> <5419BED8.5020309@redhat.com> <5419DE51.1060904@redhat.com> <CAMEtUuzhcmZiYZL8TR008or8uaefDBrEKDjqA-tOrRLEZsm95A@mail.gmail.com> <CAMEtUuw0aDPpQhd13ssk2PDLffBJNeef9jicOnhQLH6KtJ8gsQ@mail.gmail.com> <541A7F35.2010804@redhat.com> <CAMEtUuyZCHh7SGeLF+g0ye3OrEFWnTZCn3SBeK0-8qz-y8U30w@mail.gmail.com> <541AF11C.9050405@redhat.com> <CAMEtUuykgG70sP0tAmovLvPxgjwaR8h=R-c6Tyo6m96+Lg3sXQ@mail.gmail.com>
In-Reply-To: <CAMEtUuykgG70sP0tAmovLvPxgjwaR8h=R-c6Tyo6m96+Lg3sXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 05:24 PM, Alexei Starovoitov wrote:
...
> solve or not. If we decide to solve it, we need to have
> a plan to solve it all the way. Partial fix for size of bpf_attr
> is not a plan. It's something that is not addressing the problem
> completely. Little bit of help is not useful for userspace. It
> would need to deal with new types, verifier differences and
> other things that I mentioned earlier.

Hm, I don't think it would be a strict requirement to solve it
all the way, and I think that perf_event_open() with perf_copy_attr()
is not trying to do so either. It, however, is trying on a ``best
effort basis'' to still load something if new features are unused
by the binary (I guess you saw the comment in perf_copy_attr()).

Iff, e.g. due to new types we fail at the verifier stage, sure,
that's life since we only have backwards-compatible guarantee,
but in case we tried to use features we support, we're still able
to load the eBPF program while right now, we're rejecting it right
up-front. That's just my $0.02 ...

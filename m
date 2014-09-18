Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaIRPY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:24:29 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:34027 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbaIRPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <541AF11C.9050405@redhat.com>
References: <1410914370-29883-1-git-send-email-ast@plumgrid.com>
	<1410914370-29883-8-git-send-email-ast@plumgrid.com>
	<54192F66.8020200@redhat.com>
	<CAMEtUuxK68ZoJ-izjLoygv0f+rLtPmMLUUq1=BJ+_ZBGfynkdA@mail.gmail.com>
	<5419BED8.5020309@redhat.com>
	<5419DE51.1060904@redhat.com>
	<CAMEtUuzhcmZiYZL8TR008or8uaefDBrEKDjqA-tOrRLEZsm95A@mail.gmail.com>
	<CAMEtUuw0aDPpQhd13ssk2PDLffBJNeef9jicOnhQLH6KtJ8gsQ@mail.gmail.com>
	<541A7F35.2010804@redhat.com>
	<CAMEtUuyZCHh7SGeLF+g0ye3OrEFWnTZCn3SBeK0-8qz-y8U30w@mail.gmail.com>
	<541AF11C.9050405@redhat.com>
Date: Thu, 18 Sep 2014 08:24:26 -0700
Message-ID: <CAMEtUuykgG70sP0tAmovLvPxgjwaR8h=R-c6Tyo6m96+Lg3sXQ@mail.gmail.com>
Subject: Re: [PATCH v13 net-next 07/11] bpf: verifier (add ability to receive
 verification log)
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 7:50 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 09/18/2014 04:34 PM, Alexei Starovoitov wrote:
>>
>> On Wed, Sep 17, 2014 at 11:44 PM, Daniel Borkmann <dborkman@redhat.com>
>> wrote:
>
> ...
>>>
>>> Sure, you will never get a full compatibility on that regard
>>> while backwards compatibility needs to be guaranteed on the
>>> other hand. I looked at perf_copy_attr() implementation and I
>>> think that we should mimic it in a very similar way as it
>>> exactly solves what we need.
>>>
>>> For example, it will return with -EINVAL for (size > PAGE_SIZE)
>>> and (size < PERF_ATTR_SIZE_VER0) where PAGE_SIZE has been chosen
>>> as an arbitrary hard upper limit where it is believed that it will
>>> never grow beyond that large limit in future.
>>>
>>> So this is a more loose constraint than what we currently do,
>>> that is, -EINVAL on (size > sizeof(attr)) where attr is the
>>> currently known size of a specific kernel. That would at least
>>> be a start, you won't be able to cover everything though, but
>>> it would allow to address the issue raised when running with
>>> a basic feature set.
>>
>>
>> you missed my point. We should not 'do a start', since it
>> doesn't help user space in the long run and only makes
>> kernel more complex.
>
>
> Sorry, I don't think I missed your point. But if you see things
> differently, fair enough, it was just a suggestion.

now you probably think I'm shutting you up. Sorry. Was not
my intention. Let me rephrase what I meant:
I think we should decide right now whether
'new user + old kernel' is really a problem we're going to
solve or not. If we decide to solve it, we need to have
a plan to solve it all the way. Partial fix for size of bpf_attr
is not a plan. It's something that is not addressing the problem
completely. Little bit of help is not useful for userspace. It
would need to deal with new types, verifier differences and
other things that I mentioned earlier. So we either decide
that we're going to spend time to solve all of them (not
necessarily today, but over long haul) or we're not doing
any of it.

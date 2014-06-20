Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966312AbaFTKNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:13:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965185AbaFTKNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:13:37 -0400
Message-ID: <53A40948.5020201@redhat.com>
Date: Fri, 20 Jun 2014 12:13:28 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Alexei Starovoitov <ast@plumgrid.com>, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Chema Gonzalez <chema@google.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: filter: fix upper BPF instruction limit
References: <20140618223457.GA31568@www.outflux.net> <CAMEtUuzbPExM5dT+xDqbHtV5LZ3+E2Q0eq4xdmKWzLOZbTmuUQ@mail.gmail.com> <CAGXu5jLYZ0jrFhd54aUhooLBWBUT28TQTLb41G107s=4U7ZxqA@mail.gmail.com> <CAMEtUuwPug7Bbgi2ccOx4jxd2Q80AnVoiHeeBW2av=_sQMiSfg@mail.gmail.com> <CAGXu5j+ZW9f8gW71_r5gRsEZoO_2fC3F4YXh_J1CwxRY6Vfx1Q@mail.gmail.com>
In-Reply-To: <CAGXu5j+ZW9f8gW71_r5gRsEZoO_2fC3F4YXh_J1CwxRY6Vfx1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On 06/19/2014 01:28 AM, Kees Cook wrote:
> On Wed, Jun 18, 2014 at 4:19 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> On Wed, Jun 18, 2014 at 3:55 PM, Kees Cook <keescook@chromium.org> wrote:
>>> On Wed, Jun 18, 2014 at 3:48 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>>>> On Wed, Jun 18, 2014 at 3:34 PM, Kees Cook <keescook@chromium.org> wrote:
...
>>>> I wonder how did you catch this? :)
>>>> Just code inspection or seccomp actually generating such programs?
>>>
>>> In the process of merging my seccomp thread-sync series back with
>>> mainline, I got uncomfortable that I was moving filter size validation
>>> around without actually testing it. When I added it, I was happy that
>>> my series was correctly checking size limits, but then discovered my
>>> newly added check actually failed on an earlier kernel (3.2). Tracking
>>> it down found the corner case under 3.15.
>>>
>>> Here's the test I added to the seccomp regression tests, if you're interested:
>>> https://github.com/kees/seccomp/commit/794d54a340cde70a3bdf7fe0ade1f95d160b2883
>>
>> Nice. I'm assuming https://github.com/redpig/seccomp is still the main tree
>> for seccomp testsuite…
>
> Yes. Will hasn't pulled this most recent set of changes.

We were actually thinking about extending lib/test_bpf module with seccomp
tests, which is possible to a limited extend, but seccomp is also a bit
more than just running a BPF program and making sure results fit.

Are there any plans to put and extend test cases from [1] via user space
side into the kernel self-test directory, i.e. into something like
tools/testing/selftests/seccomp/ so that in future new tests can be added
or run from there? Might be worth to consider.

Thanks,

Daniel

  [1] https://github.com/redpig/seccomp

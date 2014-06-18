Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaFRWz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:55:28 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39724 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaFRWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:55:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAMEtUuzbPExM5dT+xDqbHtV5LZ3+E2Q0eq4xdmKWzLOZbTmuUQ@mail.gmail.com>
References: <20140618223457.GA31568@www.outflux.net>
	<CAMEtUuzbPExM5dT+xDqbHtV5LZ3+E2Q0eq4xdmKWzLOZbTmuUQ@mail.gmail.com>
Date: Wed, 18 Jun 2014 15:55:25 -0700
X-Google-Sender-Auth: hF-SMP2aAf2C8IBeVAhAp83fVhc
Message-ID: <CAGXu5jLYZ0jrFhd54aUhooLBWBUT28TQTLb41G107s=4U7ZxqA@mail.gmail.com>
Subject: Re: [PATCH] net: filter: fix upper BPF instruction limit
From: Kees Cook <keescook@chromium.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Chema Gonzalez <chema@google.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 3:48 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> On Wed, Jun 18, 2014 at 3:34 PM, Kees Cook <keescook@chromium.org> wrote:
>> The original checks (via sk_chk_filter) for instruction count uses ">",
>> not ">=", so changing this in sk_convert_filter has the potential to break
>> existing seccomp filters that used exactly BPF_MAXINSNS many instructions.
>>
>> Fixes: bd4cf0ed331a ("net: filter: rework/optimize internal BPF interpreter's instruction set")
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: stable@vger.kernel.org # v3.15+
>
> Acked-by: Alexei Starovoitov <ast@plumgrid.com>
>
> I wonder how did you catch this? :)
> Just code inspection or seccomp actually generating such programs?

In the process of merging my seccomp thread-sync series back with
mainline, I got uncomfortable that I was moving filter size validation
around without actually testing it. When I added it, I was happy that
my series was correctly checking size limits, but then discovered my
newly added check actually failed on an earlier kernel (3.2). Tracking
it down found the corner case under 3.15.

Here's the test I added to the seccomp regression tests, if you're interested:
https://github.com/kees/seccomp/commit/794d54a340cde70a3bdf7fe0ade1f95d160b2883

-Kees

-- 
Kees Cook
Chrome OS Security

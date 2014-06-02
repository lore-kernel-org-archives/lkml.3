Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaFBUGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:06:52 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48447 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaFBUGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:06:51 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrV0ZEFipU0E64n5q44LiUV4j4Qqvnz0h_QAoddg+e7V3A@mail.gmail.com>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
	<CAGXu5jLYPbJKCBvhVxfHEUFeCPJO-OBhRFufUSNy6o1N=LJ6UQ@mail.gmail.com>
	<CALCETrV0ZEFipU0E64n5q44LiUV4j4Qqvnz0h_QAoddg+e7V3A@mail.gmail.com>
Date: Mon, 2 Jun 2014 13:06:51 -0700
X-Google-Sender-Auth: Ukh6Jxukjfp1SFDGVjfnscVP0Rw
Message-ID: <CAGXu5j+YRW_+W8Z9S9O84ep-uUc4wQQRbtSu6_s8o5J2HLPUYg@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@google.com>, Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 12:59 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Jun 2, 2014 at 12:47 PM, Kees Cook <keescook@chromium.org> wrote:
>> Hi Andrew,
>>
>> Would you be willing to carry this series? Andy Lutomirski appears
>> happy with it now. (Thanks again for all the feedback Andy!) If so, it
>> has a relatively small merge conflict with the bpf changes living in
>> net-next. Would you prefer I rebase against net-next, let sfr handle
>> it, get carried in net-next, or some other option?
>
> Well, I'm still not entirely convinced that we want to have this much
> multiplexing in a prctl, and I'm still a bit unconvinced that the code

I don't want to get caught without interface argument flexibility
again, so that's why the prctl interface is being set up that way.

> wouldn't be better off it it were completely atomic in the sense that
> it would either work or fail without doing anything.

Getting perfect atomic operation looks extremely hard given task
locking. If this could get fixed in the future, it would have no
impact on the interface. At present, the corner case of the racing
thread is small enough that just catching the race failure is
sufficient. If task locking is improved in the future, it could just
simply never lose a race. Userspace still needs to handle errors no
matter what is the non-race failure condition (mode 1 or forked
filter) still exists.

-Kees

-- 
Kees Cook
Chrome OS Security

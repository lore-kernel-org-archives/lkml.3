Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaFCKMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:12:51 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:36812 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaFCKMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWLNFJbwaYKkjBi7XPLBQ2=gEGmW=G==+_9jcrLPW+JdA@mail.gmail.com>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
 <CAGXu5jLYPbJKCBvhVxfHEUFeCPJO-OBhRFufUSNy6o1N=LJ6UQ@mail.gmail.com>
 <CALCETrV0ZEFipU0E64n5q44LiUV4j4Qqvnz0h_QAoddg+e7V3A@mail.gmail.com>
 <CAGXu5j+YRW_+W8Z9S9O84ep-uUc4wQQRbtSu6_s8o5J2HLPUYg@mail.gmail.com>
 <CALCETrXB0zp8gwpWuxXs0bgB8sQhe6JLE46BOYw3OrBx7hQYVw@mail.gmail.com>
 <CAGXu5jKFte0ZvqU8RYcqjWDCoegWeu66gdwX83tiL8vprcvMgQ@mail.gmail.com> <CALCETrWLNFJbwaYKkjBi7XPLBQ2=gEGmW=G==+_9jcrLPW+JdA@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 3 Jun 2014 12:12:27 +0200
X-Google-Sender-Auth: fnFVmG4noKoQoZ0qWTj2IjGh6k8
Message-ID: <CAHO5Pa3F2MjfTtfNxa8LbnkeeU8=YJ+9tDqxZpw7Gz59E-4AUg@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@google.com>, Alexei Starovoitov <ast@plumgrid.com>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Kees, thank you for CCing linux-api]

On Tue, Jun 3, 2014 at 1:08 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Jun 2, 2014 at 4:05 PM, Kees Cook <keescook@chromium.org> wrote:

>> I'd like to hear from other folks on this (akpm?). My instinct is to
>> continue using prctl since that is already where mediation for seccomp
>> happens. I don't see why prctl vs a new syscall makes a difference
>> here, frankly.
>
> Aesthetics?  There's a tendency for people to get annoyed at big
> multiplexed APIs, and your patches will be doubly multiplexed.

prctl() is already a Franken-interface that provides a mass of
different, mostly completely unrelated, functionality. So, I wonder if
it would be better not to make the situation worse. Furthermore, the
very fact that the existing prctl seccomp API is being extended and
multiplexed suggests that other extensions might be desirable further
down the line, which also hints that a separate syscall would be a
good idea. (Or do we have to wait until the prctl seccomp API is
extended one more time, before we realize that a new system call would
have been a good idea...)

> TBH, I care more about the atomicity thing than about the actual form
> of the API.

User-space does not necessarily thank you for that perspective, Andy
;-). The atomicity thing is presumably fixable, regardless of the API.
On the other hand, APIs are things that kernel developers design once
and forget about, and user-space has to live with forever.

Cheers,

Michael

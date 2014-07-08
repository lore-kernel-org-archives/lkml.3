Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaGHFth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:49:37 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:40511 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaGHFtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:49:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140707112257.GA12549@ravnborg.org>
References: <CANeU7Q=a82YmUE49uZ1sOxZn0KGLuktSXuj7YsmUb=wXQEpPXA@mail.gmail.com>
	<CANeU7QmT=vzOGd6bBdkr-kNkt7yfzCWQF5QujiwV7Q8Q9hZw=w@mail.gmail.com>
	<20140707112257.GA12549@ravnborg.org>
Date: Mon, 7 Jul 2014 22:49:34 -0700
X-Google-Sender-Auth: Zz3FcGOIpHmnFteOif-mBI0oZAE
Message-ID: <CANeU7QmKtQ=KVEUM=5pMi7Rko3O3MEPB8w7Biw-r=jFtpH4_dg@mail.gmail.com>
Subject: Re: [PATCH] sparse: Add CLOG option for saving warning
From: Christopher Li <sparse@chrisli.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 4:22 AM, Sam Ravnborg <sam@ravnborg.org> wrote:

>> > Typical usage:
>> >
>> > make -j8 C=2 CLOG=<logname>
>>
> We do not need this kind of special handling of outputs from gcc.
> For sparse you just do a run with C=2 then you have it.
>
> In other words - this looks like overkill for somethign thas is achievable
> with simpler means.

I am aware of the C=2 flag. However, it does not provide consistent result
with "make -jn" flag.

Please consider that the gcc case is different. The kernel source is usually
clean of gcc warnings. If there is an error with gcc, the build process
stops. It is different with sparse. The primary goal of running sparse in
kernel build is to see those warning. Also sparse is a lot noisier than gcc
in the kernel build, so there is a need with logging which is not present
with gcc.

With this patch, here is a normal test procedure for me to see the impact of a
sparse change on kernel build:

$ make -j8 C=2 CLOG=std

# apply sparse change and make sparse

$ make -j8 C=2 CLOG=std-exp

$ find -name ".*.std.sparse" | while read -r file; do diff -du $file
${file/std.sparse/std-exp.
sparse} ; done > /tmp/sparse-diff


Without the CLOG= option, the only way to get similar diff
result is disable "-jn" option. Which make the test process painfully
slow.

I agree if I don't use "make -jn" flags, using C=2 is good enough.
However, what is your suggestion if I do want to use "make -jn" for
sparse checking in the previous mentioned usage case?

Thanks

Chris

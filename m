Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaGZS2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 14:28:13 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:56441 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaGZS2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 14:28:11 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
References: <20140723182518.GD3935@laptop>
	<CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
	<20140723184111.GG3935@laptop>
	<CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
	<20140723190230.GH3935@laptop>
	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
	<53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net>
	<20140725035527.GA30108@pg-vmw-gw1>
	<20140725140237.GB32669@home.goodmis.org>
	<CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
Date: Sat, 26 Jul 2014 11:28:10 -0700
X-Google-Sender-Auth: tVzwjslqoYLMf-MIu12GvkDDVTc
Message-ID: <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm sure it's possible, but it sounds potentially complicated.

Hmm. The bugzilla entry just taught me a new gcc flag:
"-fcompare-debug". That apparently makes gcc compile things twice,
once with debugging and once without, and verify that the result is
the same.

And you can enable it for the whole kernel build with just a simple

    export GCC_COMPARE_DEBUG=1

before doing the build.

It actually results in a failure for me even on my standard small
localized kernel build, even with gcc-4.8.3. I get a compare failure
for (at least) fs/ext4/inode.c.

That's a bit worrisome. I haven't actually checked if the code
generation differs in significant ways yet..

             Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbaGYS3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:29:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63863 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaGYS3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:29:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140725140237.GB32669@home.goodmis.org>
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
Date: Fri, 25 Jul 2014 11:29:06 -0700
X-Google-Sender-Auth: uUQQOdZczZqeN99DozWVBJ0QbfU
Message-ID: <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
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

On Fri, Jul 25, 2014 at 7:02 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> But wouldn't it be rather trivial to run a static analyzer on the final
> vmlinux to make sure there are no red zones? I mean, you would only need
> to read each function and check to make sure that the offset of rbp is
> within the change of rsp, wouldn't you?
>
> Almost seems like an objdump -rd into a perl script could do this.

I'm sure it's possible, but it sounds potentially complicated. It's
not like the function prologue is fixed, and gcc will create code
(including conditional branches etc) before the whole frame setup if
there are simple things that can be done purely with the
callee-clobbered registers etc.

Some simple pattern to make sure that the "sub $frame-size,%rsp" comes
before any accesses to (%rbp) (when frame pointers are enabled)
*might* work, but it might also end up missing things.

You want to try?

             Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3ARECJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 23:02:09 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:62044 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3ARECH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 23:02:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130118033557.GE13185@redhat.com>
References: <CACV3sb+69VQMM44vXx_-AdOZmbz18zZeVdmi1+YHEq7kZ_VmdA@mail.gmail.com>
	<y0mliceujz4.fsf@fche.csb>
	<CACV3sbKk3euv8N4SbBegJ=iYuUxfdynZ_1GNtfkwGzwGDcqATw@mail.gmail.com>
	<20130104151950.GB21860@redhat.com>
	<CACV3sbKYPUSOsccptgyJtaEp4Oxx6yX0XgVEEa+BfTPLpD28qA@mail.gmail.com>
	<20130118033557.GE13185@redhat.com>
Date: Fri, 18 Jan 2013 12:02:06 +0800
Message-ID: <CACV3sbJqFzVVL6R9x2wtqMeAxpD93k7-LV38jXQr4h_NMeUjDg@mail.gmail.com>
Subject: Re: [RFC] ktap: Another dynamic tracing tool for Linux
From: Jovi Zhang <bookjovi@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jovi.zhangwei@huawei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:35 AM, Frank Ch. Eigler <fche@redhat.com> wrote:
> Hi -
>
> On Fri, Jan 18, 2013 at 09:24:55AM +0800, Jovi Zhang wrote:
>> Let us continue this ktap topic in this thread :).
>> ktap code is public available at github, please clone from:
>> https://github.com/ktap/ktap.git
>> [...]
>
> Neat stuff.  I have one set of initial observations: even with a nice
> small bytecode language, the VM has to be skeptical and careful.  For
> example, some dangers:
>
> - any dynamic memory allocation from within the context of an
>   arbitrary tracepoints (table_* functions, stack frames)
> - unchecked arithmetic (division-by-zero - OP_DIV, overflows,
>   function arity limits)
> - time-quantity of computation (limit loop iterations / #-bytecodes?,
>   DO_JMP infinite loops)
> - stack-frame usage of interpreter (if internally recursive, or if
>   too much state kept on stack)
> - trusting validity of bytecode (imagine an attacker sending random
>   or harmful junk, jumping out of bytecode ranges)
> - calls out from interpreter into native code - to ensure that *all*
>   those functions (transitively) are valid to call from general
>   e.g. tracepoint context (e.g. sleeps often aren't)
> - (and these problems get even worse with evaluation from the
>   context of kprobes)
>
>
> - FChE

Yeh, that's why this code is called initial implementation.
most of dangers you pointed I have thought about, most of them should not
have too much hard to solve it, it just need some time, some of them already
listed in Todo-list.txt.

Thanks your quick observations, the comments is valueable, and need to
be address step by step
in future
development (I also think most issues is very common for script
dynamic tracing tool, not specific for ktap,
but ktap have to go through those barrier one by one)

Let's waiting for ktap official release 0.1, the code quality would be
more better than now :)

.jovi

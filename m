Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3ARBY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:24:58 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:39883 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3ARBY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:24:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130104151950.GB21860@redhat.com>
References: <CACV3sb+69VQMM44vXx_-AdOZmbz18zZeVdmi1+YHEq7kZ_VmdA@mail.gmail.com>
	<y0mliceujz4.fsf@fche.csb>
	<CACV3sbKk3euv8N4SbBegJ=iYuUxfdynZ_1GNtfkwGzwGDcqATw@mail.gmail.com>
	<20130104151950.GB21860@redhat.com>
Date: Fri, 18 Jan 2013 09:24:55 +0800
Message-ID: <CACV3sbKYPUSOsccptgyJtaEp4Oxx6yX0XgVEEa+BfTPLpD28qA@mail.gmail.com>
Subject: Re: [RFC] ktap: Another dynamic tracing tool for Linux
From: Jovi Zhang <bookjovi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, jovi.zhangwei@huawei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 11:19 PM, Frank Ch. Eigler <fche@redhat.com> wrote:
> Hi -
>
> bookjovi wrote:
>
>> >> [...]
>> >> ktap use lua language syntax and bytecode as initial implementation,
>> >
>> > Interesting approach.  I recall we considered it way back when, but
>> > rejected it for a couple of reasons, including the at-the-time
>> > perceived unwelcomeness of a serious bytecode interpreter within the
>> > kernel.
>
>> [...]  Obviously, the bytecode design is the biggest differences
>> with systemtap.  [...]  many Linux box doesn't deliver with gcc,
>> this is very common in embedded device, even there installed gcc,
>> but it's hard(impossible) to get matched kernel source.  [...]
>
> Right, that is a strong attraction.
>
>
>> [...]  On clear that, ktap is not a replacement to systemtap, it's
>> supplementation.
>
> FWIW, it would be reasonable to have systemtap emit bytecodes as an
> alternative backend.  All that has been lacking is a powerful and
> pervasive enough interpreter.  The script language is not tied to its
> implementation via C code generation.
>
>
> That reminds me of your item #4 on your ktap-systemtap comparison:
>
>> 4). ktap is safe, whatever you doing in script file, you will never
>> crash your kernel.
>
> This is roughly as true for systemtap as for anything else.  The
> scripts are constrainted to be safe.  Kernel crashes that occur are
> due to occasional bugs in the systemtap runtime library, or down in
> the kernel facilities being used.  You would likely encounter both
> classes of problems in a kernel-side bytecode interpreter, regardless
> of the theoretical safety of the scripting language.  (This is one of
> the reasons we've been building out the pure-userspace dyninst-based
> systemtap backend.)
>
>
>> I will try to make ktap develop progress more faster, and make ktap
>> source code public available soon.
>
> Yes, please.  (RFC/experimental code need not be complete before
> posting; why not develop straight on github?)
>
>
> - FChE

Let us continue this ktap topic in this thread :).

ktap code is public available at github, please clone from:

https://github.com/ktap/ktap.git

Brief introduction for initial building ktap:
-----------------------------------------------------------------------------------------------
ktap is a new dynamic tracing tool for Linux, it is a script environment
running in Linux kernel(similar with systemtap and Dtrace).

ktap is GPL licensed, the compiler and virtual machine is borrowed
from lua language as initial implementation.

compiler and loader is included in userspace tool ktap

compiling:
    make ktap    --- generate userspace ktap tool
    make         --- generate ktapvm kernel module

try to running ktap:
    ./ktap scripts/tracepoint.ktap

This commit is just a initial pulbic code release, it have basic
tracepoint and syscall support, please waiting ktap release 1.0. :)

I suggest you put this ktap directory into linux/kernel/trace/.

(this initial code have one issue: it need to patch ftrace code in Linux kernel,
 see ftrace.patch, I will try to get rid it sooner.)

For any question, please contact the author, Jovi Zhang.

ktap is a open source project, welcome hacking and contributing.

.jovi

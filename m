Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422638AbaE3UL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:11:28 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:52266 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaE3ULY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <5388E499.6080101@zytor.com>
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com>
 <537EB60E.40204@1h.com> <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com>
 <538658EE.8030809@zytor.com> <CALCETrUhZp+edRCx2SEzuJup0HWhV5WSiheCiZWuUjVueTJHfQ@mail.gmail.com>
 <5388E499.6080101@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 May 2014 13:11:03 -0700
Message-ID: <CALCETrX9s7xJRddB26ZiyjMEGbupbDj2qDHhio=80XSQ+staDA@mail.gmail.com>
Subject: Re: Pondering per-process vsyscall disablement
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Marian Marinov <mm@1h.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 1:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/30/2014 01:00 PM, Andy Lutomirski wrote:
>>
>> Do the flags go in the ELF loader or in the executable we're running?
>> Or both (and, if both, do we and them or or them)?
>>
>> I think the interpreter makes a little more sense in general: for the
>> most part, use of vsyscalls is a property of the runtime environment,
>> not of the program being run.  But maybe this is naive.
>>
>
> They go into each object which becomes part of the running program, i.e.
> executable, dynamic libraries, and dynamic linker.

Well, sure, but the kernel is not about to start reading ELF headers
in dynamic libraries.  So we need to make a decision based on the
interpreter and the executable.  The conservative approach is to
require both to have the flag set *and* to offer a prctl to twiddle
the flags.  Then userspace loaders can do whatever they want, and
distros get to rebuild the world :)

--Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab3EQBOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 21:14:44 -0400
Received: from ozlabs.org ([203.10.76.45]:38004 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3EQBOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 21:14:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: V3.10-rc1 memory leak
In-Reply-To: <20130516101200.GA3001@darko.cambridge.arm.com>
References: <51912567.6090507@lwfinger.net> <1368558586.6828.53.camel@gandalf.local.home> <20130514203028.GA2997@MacBook-Pro.local> <5192A847.1000100@lwfinger.net> <1368566427.6828.58.camel@gandalf.local.home> <1368579423.6828.63.camel@gandalf.local.home> <20130515143719.GB1096@darko.cambridge.arm.com> <1368646381.6828.74.camel@gandalf.local.home> <20130516101200.GA3001@darko.cambridge.arm.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 17 May 2013 09:17:12 +0930
Message-ID: <8761yia3nj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, May 15, 2013 at 08:33:01PM +0100, Steven Rostedt wrote:
>> On Wed, 2013-05-15 at 15:37 +0100, Catalin Marinas wrote:
>> 
>> > >From 0621c7e1909ea86bf8499a0ffe5ea59d1007ee8c Mon Sep 17 00:00:00 2001
>> > From: Catalin Marinas <catalin.marinas@arm.com>
>> > Date: Wed, 15 May 2013 15:30:46 +0100
>> > Subject: [PATCH] kmemleak: Scan the jump label module section
>> > 
>> > Objects allocated in jump_label_add_module() are currently reported as
>> > leaks, though the pointers are stored in the module jump label section.
>> > This patch informs kmemleak that this section needs to be scanned.
>> > 
>> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> > Reported-by: Steven Rostedt <rostedt@goodmis.org>
>> 
>> This didn't work. I still get the leak messages. But this change did:
>> 
>> Instead of just picking data sections by name (names that start
>> with .data, .bss or .ref.data), use the section flags and scan all
>> sections that are allocated, writable and not executable. Which should
>> cover all sections of a module that might reference data.
>> 
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> That's even better. I tested the two patches as well, added a subject
> and a bit of clean-up and pushed them to this branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git kmemleak
>
> Rusty, are you ok to take these or just ack and I'll push them to Linus.

Thanks.  I've dropped the original "add .ref.data" patch.

For both patches:
Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

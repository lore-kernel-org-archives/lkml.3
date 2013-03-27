Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3C0D0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:26:42 -0400
Received: from fifo99.com ([67.223.236.141]:36726 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab3C0D0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:26:41 -0400
Date: Tue, 26 Mar 2013 20:26:54 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: ptracing a task from core_pattern pipe
Message-ID: <20130327031737.GA12602@fifo99.com>
References: <20130316011508.GA11010@fifo99.com>
 <20130316175845.GA6194@redhat.com>
 <20130317004431.GA28915@fifo99.com>
 <20130317143446.GB25236@redhat.com>
 <20130317211133.GA14189@fifo99.com>
 <20130318170302.GA21248@redhat.com>
 <20130318190943.GA16226@fifo99.com>
 <20130319201933.GB18670@redhat.com>
 <51501D57.1000605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51501D57.1000605@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 10:48:07AM +0100, Denys Vlasenko wrote:
> On 03/19/2013 09:19 PM, Oleg Nesterov wrote:
> >> The above is regarding the situation which I'm running my corepipe_app ,
> >> i.e. my system doesn't have a disk to save a core file for parsing.
> > 
> > Can't you process the data inplace? You do not need to save it to disk.
> 
> Daniel said:
> 
> >> I'm trying to get the "dumpers" registers and stack out when it fails.
> 
> Registers would be easy'ish to get from coredump:
> they are contained in note sections which are at the beginning
> of the coredump. You can implement necessary parsing without
> too much pain.
> 
> Getting at stack would be harder.

There exists /proc/<pid>/mem and /proc/<pid>/maps on these tasks. If
those don't work then that's a straight up defect..

> But by asking kernel to allow you to poke around dead task's
> address space with ptrace() calls you just shift difficulty away from you
> (today you need to implement in-memory ELF parsing) to kernel people
> (they will need to implement *and support* ptracing of coredumping
> tasks).
> 
> This is somewhat unfair, considering that coredumping code in kernel
> is already a source of many complications, and that kernel-side coding
> is harder than userspace.
> 
> I think you are lucky that ptrace attach even *works* on coredumping task.
> No documentation ever guaranteed such a thing.

There not much different from userspace between a task running, and one
dumping.. I think it should be the inverse, ptrace either needs to work
or the special case needs to be documented that it doesn't work.

However, I do agree that you can parse the core file..

Daniel

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab3CYJsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab3CYJsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:48:13 -0400
Message-ID: <51501D57.1000605@redhat.com>
Date: Mon, 25 Mar 2013 10:48:07 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org
Subject: Re: ptracing a task from core_pattern pipe
References: <20130316011508.GA11010@fifo99.com> <20130316175845.GA6194@redhat.com> <20130317004431.GA28915@fifo99.com> <20130317143446.GB25236@redhat.com> <20130317211133.GA14189@fifo99.com> <20130318170302.GA21248@redhat.com> <20130318190943.GA16226@fifo99.com> <20130319201933.GB18670@redhat.com>
In-Reply-To: <20130319201933.GB18670@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 09:19 PM, Oleg Nesterov wrote:
>> The above is regarding the situation which I'm running my corepipe_app ,
>> i.e. my system doesn't have a disk to save a core file for parsing.
> 
> Can't you process the data inplace? You do not need to save it to disk.

Daniel said:

>> I'm trying to get the "dumpers" registers and stack out when it fails.

Registers would be easy'ish to get from coredump:
they are contained in note sections which are at the beginning
of the coredump. You can implement necessary parsing without
too much pain.

Getting at stack would be harder.

But by asking kernel to allow you to poke around dead task's
address space with ptrace() calls you just shift difficulty away from you
(today you need to implement in-memory ELF parsing) to kernel people
(they will need to implement *and support* ptracing of coredumping
tasks).

This is somewhat unfair, considering that coredumping code in kernel
is already a source of many complications, and that kernel-side coding
is harder than userspace.

I think you are lucky that ptrace attach even *works* on coredumping task.
No documentation ever guaranteed such a thing.

Did you try whether process_vm_readv() works on coredumping task?
If it is, then you can get at dying process' address space that way.


-- 
vda

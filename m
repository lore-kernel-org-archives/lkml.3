Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab3AQFRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:17:16 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:39391 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3AQFRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:17:15 -0500
Message-ID: <50F7888E.8000307@synopsys.com>
Date: Thu, 17 Jan 2013 10:43:50 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Arnd Bergmann <arnd@arndb.de>
CC: Gilad Ben-Yossef <gilad@benyossef.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 14/31] ARC: syscall support
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211131037.43526.arnd@arndb.de> <50A48882.3030204@synopsys.com> <201211151235.31735.arnd@arndb.de>
In-Reply-To: <201211151235.31735.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012 06:05 PM, Arnd Bergmann wrote:
> On Thursday 15 November 2012, Vineet Gupta wrote:
>> So the primary concern here is not breaking the userspace ABI - right ?
>>
>> For syscalls I agree that we will indeed need to fix the ABI - by fixing
>> uClibc. And if uClibc doesn't merge the fixes we can stay out of tree
>> for uClibc - as we currently already are.
> 
> I'm sure we can find a solution for uClibc. We already have seven
> architectures using the generic syscalls, including at least one
> (arm64) that is going to run on a large number of installations
> in the future.
> 
>> For gdbserver, the kernel provides the complete regset ABI. However it
>> also provides a very limited version of old ABI - i.e. ptrace with
>> PEEKUSR/POKEUSR. Note that latter is just a shim layer and it reuses the
>> regset callbacks. This allows us to support the legacy gdbserver. If and
>> when gdbserver upgrades it can switch over to new interface. So all
>> along there will be NO ABI breakage at all. The cost is couple extra
>> functions in kernel which we might have to maintain for some foreseeable
>> future. Agree ?
> 
> It's more a question of principle. The rule is that we don't break user
> space, and ptrace is just another user space interface is this. If
> we merge it now, we will keep it around forever, taking it out later
> is not an option IMHO. My preference would be not to merge the backwards
> compatibility layer for ptrace at all, but I'm willing to listen to
> other people that support your view if you want to keep it. In one
> way, ptrace is less critical than the other system calls, and that is
> because it's already architecture specific.
> 
> 	Arnd
> 

OK as of now the legacy syscall ABI and ptrace PEEKUSR/POKEUSR are taken out of
submissions tree - we'll carry these out-of-tree for sometime before eventually
moving to newer uClibc/gdbserver which don't need these O-O-T patches.

-Vineet

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaD1XIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:08:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:46413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbaD1XIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:08:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,947,1389772800"; 
   d="scan'208";a="531227186"
Message-ID: <535EDF67.3090501@linux.intel.com>
Date: Mon, 28 Apr 2014 16:08:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Andrew Lutomirski <amluto@gmail.com>,
        comex <comexk@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com> <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com> <535EDEC5.7030209@zytor.com>
In-Reply-To: <535EDEC5.7030209@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 04:05 PM, H. Peter Anvin wrote:
> 
> So I tried writing this bit up, but it fails in some rather spectacular
> ways.  Furthermore, I have been unable to debug it under Qemu, because
> breakpoints don't work right (common Qemu problem, sadly.)
> 
> The kernel code is at:
> 
> https://git.kernel.org/cgit/linux/kernel/git/hpa/espfix64.git/
> 
> There are two tests:
> 
> git://git.zytor.com/users/hpa/test16/test16.git, build it, and run
> ./run16 test/hello.elf
> http://www.zytor.com/~hpa/ldttest.c
> 
> The former will exercise the irq_return_ldt path, but not the fault
> path; the latter will exercise the fault path, but doesn't actually use
> a 16-bit segment.
> 
> Under the 3.14 stock kernel, the former should die with SIGBUS and the
> latter should pass.
> 

Current status of the above code: if I remove the randomization in
espfix_64.c then the first test passes; the second generally crashes the
machine.  With the randomization there, both generally crash the machine.

All my testing so far has been under KVM or Qemu, so there is always the
possibility that I'm chasing a KVM/Qemu bug, but I suspect it is
something simpler than that.

	-hpa



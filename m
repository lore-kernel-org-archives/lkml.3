Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaJASeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:34:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42829 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaJASea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:34:30 -0400
Message-ID: <542C4922.408@zytor.com>
Date: Wed, 01 Oct 2014 11:34:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
CC: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [PATCH v3 0/2] x86_64,entry: Clear NT on entry and speed up switch_to
References: <cover.1412187233.git.luto@amacapital.net>
In-Reply-To: <cover.1412187233.git.luto@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 11:28 AM, Andy Lutomirski wrote:
> Anish Bhatt noticed that user programs can set RFLAGS.NT before
> syscall or sysenter, and the kernel entry code doesn't filter out
> NT.  This causes kernel C code and, depending on thread flags, the
> exit slow path to run with NT set.
> 
> The former is a little bit scary (imagine calling into EFI with NT
> set), and the latter will fail with #GP and send a spurious SIGSEGV.
> 
> One answer would be "don't do that".  But the kernel can do better
> here.
> 
> These patches filter NT on all kernel entries.  For syscall (both
> bitnesses), this is free.  For sysenter, it seems to cost very
> little (less than my ability to measure, although I didn't try that
> hard).  Patch 2, which isn't tagged for -stable, speeds up context
> switches by avoiding saving and restoring flags, so this series
> should be a decent overall performance win.
> 
> See: https://bugs.winehq.org/show_bug.cgi?id=33275
> 
> Note to bikeshedders: I have no desire to go crazy micro-optimizing
> the sysenter path. :) This version seems to be good enough (and
> should be a performance *increase* for most workloads).
> 

The motivation for this in -stable is the Wine issue, right?  Could you
please add that to the patch description for the 1/2 patch?

Thanks,

	-hpa


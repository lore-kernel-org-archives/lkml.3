Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaI2UB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:01:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41619 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaI2UB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:01:58 -0400
Message-ID: <5429BAA7.8060406@zytor.com>
Date: Mon, 29 Sep 2014 13:01:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andy Lutomirski <luto@amacapital.net>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Sebastian Lackner <sebastian@fds-team.de>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <54299979.6080705@amacapital.net> <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de> <CALCETrX7yce2PfYi-Gqkf116a1rXUzjKkO3JAf==zd3WuZuDsQ@mail.gmail.com> <alpine.DEB.2.02.1409292135090.22082@ionos.tec.linutronix.de> <5429B664.4060003@zytor.com> <alpine.DEB.2.02.1409292152270.22082@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1409292152270.22082@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 12:57 PM, Thomas Gleixner wrote:
>  
>> I think we should mask the bit anyway.
> 
> I tend to disagree. If we clear it there we need to consequentely
> audit ALL other possibilites and if there are any we need to clear the
> bit there as well. Just to make buggy user space happy?
> 

The entry options into the kernel are: interrupt/exception (already
known to be OK), SYSENTER32, SYSCALL32, and SYSCALL64.  It is not too
much to work through those issues, I don't think.

	-hpa


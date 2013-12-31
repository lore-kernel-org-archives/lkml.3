Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3LaSnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 13:43:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43254 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab3LaSnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:43:15 -0500
Message-ID: <52C31027.2030101@zytor.com>
Date: Tue, 31 Dec 2013 10:42:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: halfdog <me@halfdog.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sanitize CPU-state when switching from virtual-8086 mode to other
 task
References: <52BF4A80.3010503@halfdog.net> <52BF8AEE.6020904@zytor.com> <52C089AC.4000401@halfdog.net> <52C0C9F4.50101@zytor.com> <52C196C3.1040300@halfdog.net>
In-Reply-To: <52C196C3.1040300@halfdog.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2013 07:52 AM, halfdog wrote:
>>
>> Still in VirtualBox?
> 
> Yes, again: after comparing the results from initrd on real hardware
> with Vbox, I'm getting to understand the timing problem involved and why
> timing in VBox is different: The test program usually OOPSes when
> touching FPU multiple times, otherwise, when terminated before second
> FPU-interacation, it OOPSes on next invocation, stumbling over invalid
> CPU state from prior invocation. With improved code, I can rather
> reliably bring CPU into that state, so that next process invoked and
> touching FPU/MMX-state is OOPSed. Currently searching SUID-binaries and
> running UID=0 daemons, that might show interesting reaction on that
> event, but only on DOS level yet, e.g. after running V2 test program
> once and then connecting via SSH, this currently kills the ssh daemon
> nicely.
> 
> It seems that machine lockup occurs when e.g. switch to idle task
> happens at exactly the right moment, which I currently cannot trigger on
> real hardware, but still working on that.
> 

I'm still wondering if this is a VirtualBox-specific problem or if it is
something that *could* occur on hardware, or in other virtualization
environments (KVM, Xen HVM, Hy-perV, VMware etc.)

	-hpa


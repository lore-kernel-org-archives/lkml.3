Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab3JQP1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:27:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38195 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755034Ab3JQP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:27:14 -0400
Date: Thu, 17 Oct 2013 11:27:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] arm64, jump label: optimize jump label
 implementation
Message-ID: <20131017112713.2638910f@gandalf.local.home>
In-Reply-To: <525FF6E0.7070000@gmail.com>
References: <1381893492-7135-1-git-send-email-liuj97@gmail.com>
	<1381893492-7135-7-git-send-email-liuj97@gmail.com>
	<20131016114608.GH5403@mudshark.cambridge.arm.com>
	<525EC8D1.7000900@gmail.com>
	<20131017093944.GB18765@mudshark.cambridge.arm.com>
	<525FF6E0.7070000@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 22:40:32 +0800
Jiang Liu <liuj97@gmail.com> wrote:


> >>> You could make the code more concise by limiting your patching ability to
> >>> branch immediates. Then a nop is simply a branch to the next instruction (I
> >>> doubt any modern CPUs will choke on this, whereas the architecture requires
> >>> a NOP to take time).
> >> I guess a NOP should be more effecient than a "B #4" on real CPUs:)
> > 
> > Well, I was actually questioning that. A NOP *has* to take time (the
> > architecture prevents implementations from discaring it) whereas a static,
> > unconditional branch will likely be discarded early on by CPUs with even
> > simple branch prediction logic.
> I naively thought "NOP" is cheaper than a "B" :(
> Will use a "B #1" to replace "NOP".
> 

Really?? What's the purpose of a NOP then? It seems to me that an
architecture is broken if a NOP is slower than a static branch.

-- Steve

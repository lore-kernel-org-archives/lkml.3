Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3JQJk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:40:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42953 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab3JQJkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:40:24 -0400
Date: Thu, 17 Oct 2013 10:39:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] arm64, jump label: optimize jump label
 implementation
Message-ID: <20131017093944.GB18765@mudshark.cambridge.arm.com>
References: <1381893492-7135-1-git-send-email-liuj97@gmail.com>
 <1381893492-7135-7-git-send-email-liuj97@gmail.com>
 <20131016114608.GH5403@mudshark.cambridge.arm.com>
 <525EC8D1.7000900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525EC8D1.7000900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 06:11:45PM +0100, Jiang Liu wrote:
> On 10/16/2013 07:46 PM, Will Deacon wrote:
> > 
> >> +	} else {
> >> +		insn = aarch64_insn_gen_nop();
> > 
> > You could make the code more concise by limiting your patching ability to
> > branch immediates. Then a nop is simply a branch to the next instruction (I
> > doubt any modern CPUs will choke on this, whereas the architecture requires
> > a NOP to take time).
> I guess a NOP should be more effecient than a "B #4" on real CPUs:)

Well, I was actually questioning that. A NOP *has* to take time (the
architecture prevents implementations from discaring it) whereas a static,
unconditional branch will likely be discarded early on by CPUs with even
simple branch prediction logic.

Will

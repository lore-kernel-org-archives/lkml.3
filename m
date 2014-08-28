Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936554AbaH1KUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:20:48 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35196 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936529AbaH1KUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:20:46 -0400
Date: Thu, 28 Aug 2014 11:20:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Wang Nan <wangnan0@huawei.com>, "David A. Long" <dave.long@linaro.org>,
        Jon Medhurst <tixy@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will.deacon@arm.com>, Pei Feiyue <peifeiyue@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] ARM: probes: check stack operation when decoding
Message-ID: <20140828102021.GC30401@n2100.arm.linux.org.uk>
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com> <1409144552-12751-2-git-send-email-wangnan0@huawei.com> <53FEFB93.2010009@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FEFB93.2010009@hitachi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 06:51:15PM +0900, Masami Hiramatsu wrote:
> (2014/08/27 22:02), Wang Nan wrote:
> > This patch improves arm instruction decoder, allows it check whether an
> > instruction is a stack store operation. This information is important
> > for kprobe optimization.
> > 
> > For normal str instruction, this patch add a series of _SP_STACK
> > register indicator in the decoder to test the base and offset register
> > in ldr <Rt>, [<Rn>, <Rm>] against sp.
> > 
> > For stm instruction, it check sp register in instruction specific
> > decoder.
> 
> OK, reviewed. but since I'm not so sure about arm32 ISA,
> I need help from ARM32 maintainer to ack this.

What you actually need is an ack from the ARM kprobes people who
understand this code.  That would be much more meaningful than my
ack.  They're already on the Cc list.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

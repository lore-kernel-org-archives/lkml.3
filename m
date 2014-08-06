Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaHFW5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:57:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39545 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754443AbaHFW5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:57:33 -0400
Date: Wed, 6 Aug 2014 23:57:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Wang Nan <wangnan0@huawei.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, peifeiyue@huawei.com
Subject: Re: [RFC PATCH] kprobes: arm: enable OPTPROBES for arm 32
Message-ID: <20140806225719.GW30282@n2100.arm.linux.org.uk>
References: <1407223697-74911-1-git-send-email-wangnan0@huawei.com> <1407335003.3006.38.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407335003.3006.38.camel@linaro1.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 03:23:23PM +0100, Jon Medhurst (Tixy) wrote:
> On Tue, 2014-08-05 at 15:28 +0800, Wang Nan wrote:
> > +static inline int
> > +arm_branch_to_addr(unsigned int *pinst, void *src, void *dest)
> > +{
> > +	unsigned int inst = 0xea000000;
> > +	long offset = (unsigned long)(dest) -
> > +			((unsigned long)(src) + 8);
> > +	if ((offset > 0x3fffffc) || (offset < -0x3fffffc)) {
> > +		printk(KERN_WARNING "Failed to instrument %pS to %pS\n", src, dest);
> > +		return -EINVAL;
> > +	}
> > +
> > +	inst |= (((unsigned long)offset) >> 2) & (0x00ffffffUL);
> > +	*pinst = inst;
> > +	return 0;
> > +}
> > +
> 
> This looks remarkably similar to the code in arch/arm/kernel/insn.c so I
> think you can probably just use the existing arm_gen_branch() function.

Which would be a better idea as the version found in insn.c is not
buggy.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

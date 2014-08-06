Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaHFOYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:24:15 -0400
Received: from queue01b.mail.zen.net.uk ([212.23.3.242]:59152 "EHLO
	queue01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaHFOYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:24:13 -0400
X-Greylist: delayed 2711 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 10:24:13 EDT
Message-ID: <1407332208.3006.13.camel@linaro1.home>
Subject: Re: [RFC PATCH] kprobes: arm: enable OPTPROBES for arm 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Wang Nan <wangnan0@huawei.com>, Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Li Zefan <lizefan@huawei.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, peifeiyue@huawei.com
Date: Wed, 06 Aug 2014 14:36:48 +0100
In-Reply-To: <53E1B2A0.1040807@hitachi.com>
References: <1407223697-74911-1-git-send-email-wangnan0@huawei.com>
	 <53E1B2A0.1040807@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 13:44 +0900, Masami Hiramatsu wrote:
> (2014/08/05 16:28), Wang Nan wrote
[...]
> > +asm (
> > +			".global optprobe_template_entry\n"
> > +			"optprobe_template_entry:\n"
> > +#ifndef CONFIG_THUMB
> > +			"	sub	sp, sp, #80\n"
> > +			"	stmia	sp, {r0 - r14} \n"
> > +			"	add	r3, sp, #80\n"
> > +			"	str	r3, [sp, #52]\n"
> > +			"	mrs	r4, cpsr\n"
> > +			"	str	r4, [sp, #64]\n"
> > +			"	mov	r1, sp\n"
> > +			"	ldr	r0, 1f\n"
> > +			"	ldr	r2, 2f\n"
> > +			"	blx	r2\n"
> > +			"	ldr	r1, [sp, #64]\n"
> > +			"	msr	cpsr_fs, r1\n"
> > +			"	ldmia	sp, {r0 - r15}\n"
> > +			".global optprobe_template_val\n"
> > +			"optprobe_template_val:\n"
> > +			"1:	nop\n"
> > +			".global optprobe_template_call\n"
> > +			"optprobe_template_call:\n"
> > +			"2:	nop\n"
> > +#else /* CONFIG_THUMB */
> > +# error optprobe for thumb is not supported.
> 
> Can we set CONFIG_THUMB=y without CONFIG_THUMB2_KERNEL ?

Yes, CONFIG_THUMB is for supporting userside Thumb code,
CONFIG_THUMB2_KERNEL is for building the kernel for Thumb and the
options are orthogonal. So I don't think kprobes code should be testing
CONFIG_THUMB as it doesn't deal with userside.

-- 
Tixy


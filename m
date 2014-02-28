Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaB1OMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:12:10 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:34758 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbaB1OMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:12:08 -0500
Message-ID: <1393596692.3601.37.camel@linaro1.home>
Subject: Re: [PATCH v6 07/14] ARM: Remove use of struct kprobe from generic
 probes code
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Long <dave.long@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2014 14:11:32 +0000
In-Reply-To: <20140228101226.GO21483@n2100.arm.linux.org.uk>
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org>
	 <1392017945-4507-8-git-send-email-dave.long@linaro.org>
	 <20140228101226.GO21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 10:12 +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 10, 2014 at 02:38:58AM -0500, David Long wrote:
> > diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
> > index 7cd1763..179deac 100644
> > --- a/arch/arm/kernel/probes.c
> > +++ b/arch/arm/kernel/probes.c
> > @@ -12,11 +12,9 @@
> >   */
> >  
> >  #include <linux/kernel.h>
> > -#include <linux/kprobes.h>
> >  #include <asm/system_info.h>
> 
> How well has this code been tested?

>From the error below I assume only when __LINUX_ARM_ARCH__ >= 7

I have v5 and v6 hardware and will give it a go on those. I would do v4
but I've no idea how to get a kernel onto the Assabet I rescued from a
skip...

>   This file doesn't even build because
> (I suspect) the above change:
> 
> arch/arm/kernel/probes.c: In function 'test_alu_write_pc_interworking':
> arch/arm/kernel/probes.c:68:2: error: implicit declaration of function 'BUG_ON' [-Werror=implicit-function-declaration]
> make[2]: *** [arch/arm/kernel/probes.o] Error 1
> 
> This is because linux/kprobes.h includes linux/bug.h, which would provide
> the requirements for BUG_ON().

-- 
Tixy


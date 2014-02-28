Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaB1KNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:13:18 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57918 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750957AbaB1KNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:13:16 -0500
Date: Fri, 28 Feb 2014 10:12:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 07/14] ARM: Remove use of struct kprobe from generic
	probes code
Message-ID: <20140228101226.GO21483@n2100.arm.linux.org.uk>
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org> <1392017945-4507-8-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392017945-4507-8-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:38:58AM -0500, David Long wrote:
> diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
> index 7cd1763..179deac 100644
> --- a/arch/arm/kernel/probes.c
> +++ b/arch/arm/kernel/probes.c
> @@ -12,11 +12,9 @@
>   */
>  
>  #include <linux/kernel.h>
> -#include <linux/kprobes.h>
>  #include <asm/system_info.h>

How well has this code been tested?  This file doesn't even build because
(I suspect) the above change:

arch/arm/kernel/probes.c: In function 'test_alu_write_pc_interworking':
arch/arm/kernel/probes.c:68:2: error: implicit declaration of function 'BUG_ON' [-Werror=implicit-function-declaration]
make[2]: *** [arch/arm/kernel/probes.o] Error 1

This is because linux/kprobes.h includes linux/bug.h, which would provide
the requirements for BUG_ON().

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

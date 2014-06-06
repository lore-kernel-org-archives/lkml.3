Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaFFFfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 01:35:41 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52919 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaFFFfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 01:35:39 -0400
Message-ID: <539152B3.5070702@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2014 11:03:39 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc/powernv: include asm/smp.h to handle UP config
References: <1401981695-3682-1-git-send-email-shreyas@linux.vnet.ibm.com>
In-Reply-To: <1401981695-3682-1-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060605-3568-0000-0000-000005A30161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 08:51 PM, Shreyas B. Prabhu wrote:
> Build throws following errors when CONFIG_SMP=n
> arch/powerpc/platforms/powernv/setup.c: In function ‘pnv_kexec_wait_secondaries_down’:
> arch/powerpc/platforms/powernv/setup.c:179:4: error: implicit declaration of function ‘get_hard_smp_processor_id’
>     rc = opal_query_cpu_status(get_hard_smp_processor_id(i),
> 
> The usage of get_hard_smp_processor_id() needs the declaration from
> <asm/smp.h>. The file setup.c includes <linux/sched.h>, which in-turn
> includes <linux/smp.h>. However, <linux/smp.h> includes <asm/smp.h>
> only on SMP configs and hence UP builds fail.
> 
> Fix this by directly including <asm/smp.h> in setup.c unconditionally.

Can you please clean up the description in the commit message ? and also
the first line in the commit message should mention that the patch is
trying to fix a UP specific build failure.


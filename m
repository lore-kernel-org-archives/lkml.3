Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaFFLDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:03:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:50229 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaFFLDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:03:44 -0400
Message-ID: <1402052599.3247.225.camel@pasglop>
Subject: Re: [PATCH 1/2] powerpc/powernv: include asm/smp.h to handle UP
 config
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Fri, 06 Jun 2014 21:03:19 +1000
In-Reply-To: <539152B3.5070702@linux.vnet.ibm.com>
References: <1401981695-3682-1-git-send-email-shreyas@linux.vnet.ibm.com>
	 <539152B3.5070702@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 11:03 +0530, Anshuman Khandual wrote:
> On 06/05/2014 08:51 PM, Shreyas B. Prabhu wrote:
> > Build throws following errors when CONFIG_SMP=n
> > arch/powerpc/platforms/powernv/setup.c: In function ‘pnv_kexec_wait_secondaries_down’:
> > arch/powerpc/platforms/powernv/setup.c:179:4: error: implicit declaration of function ‘get_hard_smp_processor_id’
> >     rc = opal_query_cpu_status(get_hard_smp_processor_id(i),
> > 
> > The usage of get_hard_smp_processor_id() needs the declaration from
> > <asm/smp.h>. The file setup.c includes <linux/sched.h>, which in-turn
> > includes <linux/smp.h>. However, <linux/smp.h> includes <asm/smp.h>
> > only on SMP configs and hence UP builds fail.
> > 
> > Fix this by directly including <asm/smp.h> in setup.c unconditionally.
> 
> Can you please clean up the description in the commit message ? and also
> the first line in the commit message should mention that the patch is
> trying to fix a UP specific build failure.

I don't understand your comment ... the description and subject line
are perfectly fine...

Ben.



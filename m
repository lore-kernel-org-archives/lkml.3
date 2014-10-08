Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbaJHRRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:17:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58961 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJHRRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:17:24 -0400
Date: Wed, 8 Oct 2014 10:16:50 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        mikey@neuling.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, palves@redhat.com, oleg@redhat.com,
        dhowells@redhat.com, davej@redhat.com, davem@davemloft.net
Subject: Re: [PATCH V3 3/3] powerpc, ptrace: Enable support for miscellaneous
 registers
Message-ID: <20141008171650.GA7110@us.ibm.com>
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
 <1400858138-3939-4-git-send-email-khandual@linux.vnet.ibm.com>
 <20140827213559.GB11489@us.ibm.com>
 <54356444.1080702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <54356444.1080702@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100817-8236-0000-0000-000006020FA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anshuman Khandual [khandual@linux.vnet.ibm.com] wrote:
| On 08/28/2014 03:05 AM, Sukadev Bhattiprolu wrote:
| > 
| > I see these in  arch/powerpc/include/asm/processor.h
| > 
| > #ifdef CONFIG_PPC64
| >         unsigned long   dscr;
| >         int             dscr_inherit;
| >         unsigned long   ppr;    /* used to save/restore SMT priority */
| > #endif
| > 
| > where there is an 'int' between ppr and dscr. So, should one of
| > the above sizeof(unsigned long) be changed to sizeof(int) ?
| 
| Right, I understand that but strangely I get this compile time error
| when it is changed to sizeof(int).
| 
|  error: call to ‘__compiletime_assert_1350’ declared with attribute error:
|   BUILD_BUG_ON failed: TSO(dscr) + sizeof(unsigned long) + sizeof(int) != TSO(ppr)
|   BUILD_BUG_ON(TSO(dscr) + sizeof(unsigned long) + sizeof(int) != TSO(ppr));
| 
| may be I am missing something here.

I guess there is a 4-byte padding after dscr_inherit. We could make that
explicit by adding a field or just go with the sizeof(unsigned long).

Thanks,

Sukadev


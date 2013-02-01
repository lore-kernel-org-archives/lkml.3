Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab3BAVGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:06:55 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:52780 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab3BAVGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:06:51 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: RE: [RFC][PATCH v8 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [RFC][PATCH v8 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac34JJMyFwTt3KidTvasHhLQsjVWNwIxO5IAAApzF3A=
Date: Fri, 1 Feb 2013 21:06:02 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A5F834@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A508CE@USINDEM103.corp.hds.com>
 <1359752614.5642.49.camel@gandalf.local.home>
In-Reply-To: <1359752614.5642.49.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-01_05:2013-02-01,2013-02-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302010152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#include <asm/hw_irq.h>
> > +#include <asm/desc.h>
> > +
> > +static struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
> > +				    (unsigned long) trace_idt_table };
> > +
> > +#ifndef CONFIG_X86_64
> > +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
> > +					= { { { { 0, 0 } } }, };
> > +#endif
> > +
> > +static struct desc_ptr orig_idt_descr[NR_CPUS];
> 
> BTW, this should be:
> 
> static DEFINE_PER_CPU(struct desc_ptr, orig_idt_descr);
> 
> And look at the patch I made about the NMI/DEBUG trap handling to see how to use it.

Thanks.
I'm looking at your patch right now and will update my patch.

Seiji

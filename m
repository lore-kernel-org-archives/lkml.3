Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaIVVEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:04:39 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:10087 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaIVVEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:04:37 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        x86 <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: RE: [patch 22/26] x86: Add proper vector accounting for HyperV
Thread-Topic: [patch 22/26] x86: Add proper vector accounting for HyperV
Thread-Index: AQHP1qe4bKciWkPPsk6mOx38tYrEmZwNosVg
Date: Mon, 22 Sep 2014 21:03:57 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C91F27@G9W0745.americas.hpqcorp.net>
References: <20140223212703.511977310@linutronix.de>
 <20140223212738.681855582@linutronix.de>
In-Reply-To: <20140223212738.681855582@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Thomas Gleixner
> Sent: Sunday, 23 February, 2014 3:40 PM
> To: LKML
> Cc: Ingo Molnar; Peter Zijlstra; x86; Konrad Rzeszutek Wilk; K. Y. Srinivasan
> Subject: [patch 22/26] x86: Add proper vector accounting for HyperV
> 
> HyperV abuses a device interrupt to account for the
> HYPERVISOR_CALLBACK_VECTOR.
> 
> Provide proper accounting as we have for the other vectors as well.
...
> Index: tip/arch/x86/kernel/irq.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/irq.c
> +++ tip/arch/x86/kernel/irq.c
> @@ -125,6 +125,12 @@ int arch_show_interrupts(struct seq_file
>  		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
>  	seq_printf(p, "  Machine check polls\n");
>  #endif
> +#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
> +	seq_printf(p, "%*s: ", prec, "THR");
> +	for_each_online_cpu(j)
> +		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
> +	seq_printf(p, "  Hypervisor callback interrupts\n");
> +#endif
...

Should this have used a different short string than "THR",
which is already used for "Threshold APIC interrupts"?

---
Rob Elliott    HP Server Storage




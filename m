Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaJAHEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:04:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:27954 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaJAHEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:04:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,630,1406617200"; 
   d="scan'208";a="581710439"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "'Bryan O'Donoghue'" <pure.logic@nexus-software.ie>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "davej@redhat.com" <davej@redhat.com>,
        "hmh@hmh.eng.br" <hmh@hmh.eng.br>
Subject: RE: [PATCH 2/2] x86: Quark: Comment setup_arch for TLB/PGE bugfix
Thread-Topic: [PATCH 2/2] x86: Quark: Comment setup_arch for TLB/PGE bugfix
Thread-Index: AQHP3Qgt8nUkJSPpX0ShwZdRTguIcJwa0EDA
Date: Wed, 1 Oct 2014 06:59:42 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B73259F8F5@pgsmsx105.gar.corp.intel.com>
References: <1412120517-14738-1-git-send-email-pure.logic@nexus-software.ie>
 <1412120517-14738-3-git-send-email-pure.logic@nexus-software.ie>
In-Reply-To: <1412120517-14738-3-git-send-email-pure.logic@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Bryan O'Donoghue
> Sent: Wednesday, October 01, 2014 7:42 AM
> To: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> davej@redhat.com; hmh@hmh.eng.br
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; Bryan O'Donoghue
> Subject: [PATCH 2/2] x86: Quark: Comment setup_arch for TLB/PGE bugfix
> 
> Quark X1000 requires CR3 to be rewritten to flush TLB entries irrespective of
> the PGE bits in CR4 or PTE.PGE
> 
> Add a comment to setup_arch to indicate that the code
> 
> load_cr3(swapper_pg_dir);
> __flush_tlb_all();
> 
> Will already have flushed the TLB @ the CR3 reload allowing us to skip over a
> potential if/else for Quark.
> 
> This comment clearly states the bug, the behaviour we rely on and the reason
> why we only do it this way - one time.
> 
> Later on cpu_has_pge() will be false due to a fixup in
> intel_init_early() and __flush_tlb_all() will work as expected from that point
> onwards

s/intel_init_early/early_init_intel


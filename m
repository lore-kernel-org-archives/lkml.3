Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3JKXQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:16:24 -0400
Received: from mail-bn1lp0149.outbound.protection.outlook.com ([207.46.163.149]:51563
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab3JKXQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:16:12 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [patch x86/hyperv] x86, hyperv: Fix build error
Thread-Topic: [patch x86/hyperv] x86, hyperv: Fix build error
Thread-Index: AQHOxta5P1yA7RPLC0+Qc4gHG+R3tJnwIZhQ
Date: Fri, 11 Oct 2013 23:16:09 +0000
Message-ID: <86627d477ccc42aea289f62ad96d0e4b@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1380554932-9888-1-git-send-email-olaf@aepfle.de>
 <tip-9e7827b5ea4ca93b4d864bc07c0fafb838d496b1@git.kernel.org>
 <alpine.DEB.2.02.1310111604160.31170@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1310111604160.31170@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-forefront-prvs: 0996D1900D
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(377454003)(13464003)(51704005)(74706001)(76482001)(56776001)(50986001)(49866001)(63696002)(53806001)(4396001)(33646001)(47976001)(79102001)(74366001)(85306002)(47736001)(54356001)(46102001)(65816001)(54316002)(83072001)(80022001)(80976001)(81686001)(59766001)(77982001)(19580405001)(69226001)(83322001)(76576001)(76796001)(74502001)(74662001)(47446002)(19580395003)(77096001)(31966008)(56816003)(81542001)(81816001)(81342001)(51856001)(74876001)(76786001)(74316001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::3;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Rientjes [mailto:rientjes@google.com]
> Sent: Friday, October 11, 2013 4:08 PM
> To: Ingo Molnar; H. Peter Anvin; tglx@linutronix.de; H. Peter Anvin
> Cc: KY Srinivasan; Olaf Hering; linux-kernel@vger.kernel.org; linux-tip-
> commits@vger.kernel.org
> Subject: [patch x86/hyperv] x86, hyperv: Fix build error
> 
> 9e7827b5ea4c ("x86, hyperv: Get the local APIC timer frequency from the
> hypervisor") breaks the build with some configs because apic.h isn't
> directly included:
> 
> arch/x86/kernel/cpu/mshyperv.c: In function 'ms_hyperv_init_platform':
> arch/x86/kernel/cpu/mshyperv.c:90:3: error: 'lapic_timer_frequency' undeclared
> (first use in this function)
> arch/x86/kernel/cpu/mshyperv.c:90:3: note: each undeclared identifier is
> reported only once for each function it appears in
> 
> Fix it by including asm/apic.h.

Thank you. The issue was configuration related - local APIC was not configured. This has already been fixed.

Regards.

K. Y
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/kernel/cpu/mshyperv.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -25,6 +25,7 @@
>  #include <asm/idle.h>
>  #include <asm/irq_regs.h>
>  #include <asm/i8259.h>
> +#include <asm/apic.h>
> 
>  struct ms_hyperv_info ms_hyperv;
>  EXPORT_SYMBOL_GPL(ms_hyperv);

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbaDBGZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 02:25:43 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:9581
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756577AbaDBGZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 02:25:42 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 1/1] x86: irq: Handle VMBUS driver being a module
Thread-Topic: [PATCH 1/1] x86: irq: Handle VMBUS driver being a module
Thread-Index: AQHPTjh2EckFuER8cUWIZcZJ4Ydbppr925jQ
Date: Wed, 2 Apr 2014 06:25:39 +0000
Message-ID: <9964b317d8a1487d9dcd3fb53d7e8d1c@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1396421502-23222-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1396421502-23222-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.19.246.69]
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(189002)(199002)(51704005)(13464003)(20776003)(56816005)(93516002)(65816001)(83072002)(66066001)(93136001)(85306002)(63696002)(80022001)(76576001)(76796001)(86362001)(94946001)(2201001)(85852003)(59766001)(77982001)(47446002)(87266001)(81342001)(97336001)(81542001)(99286001)(2656002)(76786001)(87936001)(33646001)(74662001)(95416001)(79102001)(94316002)(51856001)(1511001)(49866001)(92566001)(90146001)(56776001)(81816001)(19580405001)(54356001)(98676001)(54316002)(4396001)(76482001)(53806001)(83322001)(97186001)(47976001)(74366001)(74316001)(19580395003)(74876001)(74706001)(74502001)(47736001)(81686001)(86612001)(95666003)(50986001)(46102001)(31966008)(80976001)(69226001)(99396002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:B8DFF955.98BFAF28.32FA1B4C.86807AFA.20248;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

With the Hyper-V irq cleanup that you checked in, currently Hyper-V interrupts are not being displayed when
Hyper-V is configured as a module. This patch fixes the issue.

Regards,

K. Y

> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, April 1, 2014 11:52 PM
> To: x86@kernel.org; linux-kernel@vger.kernel.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> hpa@zytor.com
> Cc: KY Srinivasan
> Subject: [PATCH 1/1] x86: irq: Handle VMBUS driver being a module
> 
> Hyper-V VMBUS driver can be a module; handle this case correctly. Please
> apply.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  arch/x86/kernel/irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 42805fa..283a76a 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -125,7 +125,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
>  		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
>  	seq_printf(p, "  Machine check polls\n");
>  #endif
> -#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
> +#if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
>  	seq_printf(p, "%*s: ", prec, "THR");
>  	for_each_online_cpu(j)
>  		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
> --
> 1.7.4.1


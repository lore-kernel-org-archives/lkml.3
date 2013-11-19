Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3KSRVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:21:41 -0500
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:21700
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751624Ab3KSRVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:21:39 -0500
Message-ID: <528B9E12.7060108@caviumnetworks.com>
Date: Tue, 19 Nov 2013 09:21:22 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Michal Marek <mmarek@suse.cz>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: Re: [PATCH] ARC: extable: Enable sorting at build time
References: <1384497942-26810-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1384497942-26810-1-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 0035B15214
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(189002)(199002)(24454002)(377454003)(479174003)(51704005)(4396001)(36756003)(65956001)(19580405001)(83322001)(19580395003)(74366001)(54356001)(76482001)(81686001)(81816001)(46102001)(50986001)(76786001)(47976001)(23756003)(50466002)(53416003)(76796001)(74662001)(56816003)(80316001)(77096001)(47736001)(63696002)(47776003)(49866001)(66066001)(80022001)(65806001)(80976001)(83506001)(83072001)(33656001)(53806001)(79102001)(74706001)(74502001)(47446002)(74876001)(51856001)(85306002)(54316002)(56776001)(81542001)(64126003)(81342001)(69226001)(31966008)(59766001)(77982001)(59896001)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR07MB133;H:BY2PRD0712HT001.namprd07.prod.outlook.com;CLIP:64.2.3.195;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 10:45 PM, Vineet Gupta wrote:
> Avoids wasting cycles at boot specially on slower simulators
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: David Daney <david.daney@cavium.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Francois Bedard <fbedard@synopsys.com>
> Cc: linux-kernel@vger.kernel.org

I haven't tested it, but this looks sane.

Acked-by: David Daney <david.daney@cavium.com>

I have no opinion about the path this should take towards Linus' tree.

> ---
>   arch/arc/Kconfig      | 1 +
>   scripts/sortextable.c | 5 +++++
>   2 files changed, 6 insertions(+)
>
> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
> index 91dbb2757afd..080580216301 100644
> --- a/arch/arc/Kconfig
> +++ b/arch/arc/Kconfig
> @@ -8,6 +8,7 @@
>
>   config ARC
>   	def_bool y
> +	select BUILDTIME_EXTABLE_SORT
>   	select CLONE_BACKWARDS
>   	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
>   	select DEVTMPFS if !INITRAMFS_SOURCE=""
> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
> index 7c2310c5b996..e3fb1c36ed0f 100644
> --- a/scripts/sortextable.c
> +++ b/scripts/sortextable.c
> @@ -31,6 +31,10 @@
>   #include <tools/be_byteshift.h>
>   #include <tools/le_byteshift.h>
>
> +#ifndef EM_ARCOMPACT
> +#define EM_ARCOMPACT	93
> +#endif
> +
>   #ifndef EM_AARCH64
>   #define EM_AARCH64	183
>   #endif
> @@ -244,6 +248,7 @@ do_file(char const *const fname)
>   	case EM_S390:
>   		custom_sort = sort_relative_table;
>   		break;
> +	case EM_ARCOMPACT:
>   	case EM_ARM:
>   	case EM_AARCH64:
>   	case EM_MIPS:
>


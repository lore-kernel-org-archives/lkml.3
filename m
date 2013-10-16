Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab3JPXyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:54:14 -0400
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:29141
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab3JPXyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:54:12 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2013 19:54:12 EDT
Message-ID: <525F2397.40203@caviumnetworks.com>
Date: Wed, 16 Oct 2013 16:39:03 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Bohan <mbohan@codeaurora.org>,
        David Gibson <david@gibson.dropbear.id.au>
CC: <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <ralf@linux-mips.org>,
        <devicetree-discuss@lists.ozlabs.org>, <david.daney@cavium.com>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] of/lib: Export fdt routines to modules
References: <1381966065-16854-1-git-send-email-mbohan@codeaurora.org>
In-Reply-To: <1381966065-16854-1-git-send-email-mbohan@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 0001227049
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(377454003)(479174003)(51704005)(24454002)(189002)(199002)(4396001)(47976001)(80022001)(65956001)(47736001)(49866001)(81542001)(74876001)(81342001)(66066001)(65806001)(83072001)(50986001)(53416003)(19580395003)(83322001)(33656001)(19580405001)(64126003)(80976001)(79102001)(76796001)(76786001)(50466002)(54316002)(85306002)(56776001)(56816003)(77096001)(36756003)(74662001)(74502001)(47446002)(76482001)(69226001)(74366001)(81686001)(31966008)(83506001)(81816001)(59766001)(77982001)(74706001)(46102001)(54356001)(47776003)(63696002)(53806001)(23756003)(51856001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR07MB012;H:BL2PRD0712HT001.namprd07.prod.outlook.com;CLIP:64.2.3.195;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 04:27 PM, Michael Bohan wrote:
> Ever since the following commit, libfdt has been available for
> usage in the kernel:
>
>       commit ab25383983fb8d7786696f5371e75e79c3e9a405
>       Author: David Daney <david.daney@cavium.com>
>       Date:   Thu Jul 5 18:12:38 2012 +0200
>
>       of/lib: Allow scripts/dtc/libfdt to be used from kernel code
>
> Export these functions to modules so that they may be used
> from device drivers.
>
> Change-Id: I7f540b7cf860c4be414e32ce183be5268b2ae6af
> Signed-off-by: Michael Bohan <mbohan@codeaurora.org>
> ---
>   lib/fdt.c     |    6 ++++++
>   lib/fdt_ro.c  |   28 ++++++++++++++++++++++++++++
>   lib/fdt_rw.c  |   13 +++++++++++++
>   lib/fdt_sw.c  |    9 +++++++++
>   lib/fdt_wip.c |    6 ++++++
>   5 files changed, 62 insertions(+), 0 deletions(-)
>
> diff --git a/lib/fdt.c b/lib/fdt.c
> index 97f2006..a3fe87b 100644
> --- a/lib/fdt.c
> +++ b/lib/fdt.c
> @@ -1,2 +1,8 @@
>   #include <linux/libfdt_env.h>
> +#include <linux/module.h>
>   #include "../scripts/dtc/libfdt/fdt.c"
> +
> +EXPORT_SYMBOL_GPL(fdt_next_tag);

The code was all written by David Gibson, and is dual GPL/BSD licensed. 
  So I am not sure you should be using the GPL flavor of the export 
directive.


But more than this.  I don't understand why a driver would be parsing 
the FDT in the first place.  If there is a device tree, why hasn't it 
been unflattened, and thus used via the normal device tree functions.

David Daney

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3HBW1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:27:00 -0400
Received: from [207.46.163.210] ([207.46.163.210]:58088 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753554Ab3HBW07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:26:59 -0400
Message-ID: <51FC31AF.1070802@caviumnetworks.com>
Date: Fri, 2 Aug 2013 15:24:47 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 3/3] smp.h: Move !SMP version of on_each_cpu() out-of-line
References: <1375477776-13302-1-git-send-email-ddaney.cavm@gmail.com> <1375477776-13302-4-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1375477776-13302-4-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 0926B0E013
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(479174003)(189002)(199002)(377454003)(51704005)(24454002)(65956001)(63696002)(19580395003)(77982001)(16406001)(54356001)(50986001)(46102001)(56776001)(36756003)(81342001)(59766001)(59896001)(47776003)(74366001)(47446002)(66066001)(19580405001)(74502001)(83322001)(74662001)(65806001)(51856001)(80022001)(80316001)(31966008)(47976001)(23756003)(54316002)(76796001)(76786001)(79102001)(53806001)(4396001)(74876001)(50466002)(80976001)(56816003)(81542001)(69226001)(74706001)(77096001)(53416003)(64126003)(49866001)(83072001)(47736001)(76482001)(33656001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB132;H:BL2PRD0712HT004.namprd07.prod.outlook.com;CLIP:64.2.3.195;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 02:09 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
>
> All of the other non-trivial !SMP versions of functions in smp.h are
>  out-of-line in up.c.  Move on_each_cpu() there as well.
>
> This allows us to get rid of the #include <linux/irqflags.h>.  The
> drawback is that this makes both the x86_64 and i386 defconfig !SMP
> kernels about 200 bytes larger each.

I looked at the cause of the size difference and there are several main
parts to it.

1) kallsym data (28 bytes).

2) with the patch generating a function pointer to pass to on_each_cpu 
vs. direct call (7 bytes * 22 call sites) and generating the the ignored 
third parameter (5 bytes * 22 call sites); without the patch 
local_irq_save/local_irq_restore(5 bytes * 22 call sites)  for a total 
of 7 * 22 == 154 bytes.

3) Other (21 bytes).

>
> Signed-off-by: David Daney <david.daney@cavium.com> ---
> include/linux/smp.h | 21 +++++---------------- kernel/up.c         |
> 11 +++++++++++ 2 files changed, 16 insertions(+), 16 deletions(-)
>


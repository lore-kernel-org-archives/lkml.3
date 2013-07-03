Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab3GCRct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 13:32:49 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:57822
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932304Ab3GCRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 13:32:48 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MPDFEC-02-4L9-02
X-M-MSG: 
Message-ID: <51D46034.5000209@amd.com>
Date: Wed, 3 Jul 2013 12:32:36 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.11
References: <20130701090356.GA14912@gmail.com> <CA+55aFwJwYRbPBBN1ma8TBHuomo_AJjajxT6YDmdGXJdE4EgrQ@mail.gmail.com> <20130703075542.GF23916@twins.programming.kicks-ass.net>
In-Reply-To: <20130703075542.GF23916@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/2013 2:55 AM, Peter Zijlstra wrote:
> On Tue, Jul 02, 2013 at 05:50:29PM -0700, Linus Torvalds wrote:
>> On Mon, Jul 1, 2013 at 2:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus
>>>
>>> Kernel improvements:
>>>
>>>   * AMD IOMMU uncore PMU support by Suravee Suthikulpanit001a
>> This one prints a really annoying error message if you're not on an
>> AMD platform:
>>
>> +       if (!amd_iommu_pc_supported()) {
>> +               pr_err("perf: amd_iommu PMU not installed. No support!\n");
>> +               return -ENODEV;
>> +       }
>>
>> and you know what? That's not acceptable. It damn well is *not* an
>> error to not have an AMD IOMMU.
>>
>> It should - at most - be a pr_info(). Maybe nothing at all. "pr_err()"
>> is just totally out of line.
> Quite; it prints enough stuff when it does find one so I'm all for
> scrapping that one print when it doesn't find it.
>
> Sorry for not seeing that; when I initially read that code I thought it was for
> the case where the hardware was expected to have the device but we couldn't
> find it for some weird reason.
>
> ---
> Subject: perf, amd: Do not print an error when the device is not present
>
> As Linus said its not an error to not have an AMD IOMMU; esp. when you're not
> even running on an AMD platform.
>
> Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>   arch/x86/kernel/cpu/perf_event_amd_iommu.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.c b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
> index 0db655e..639d128 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd_iommu.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
> @@ -491,10 +491,8 @@ static struct perf_amd_iommu __perf_iommu = {
>   static __init int amd_iommu_pc_init(void)
>   {
>   	/* Make sure the IOMMU PC resource is available */
> -	if (!amd_iommu_pc_supported()) {
> -		pr_err("perf: amd_iommu PMU not installed. No support!\n");
> +	if (!amd_iommu_pc_supported())
>   		return -ENODEV;
> -	}
>   
>   	_init_perf_amd_iommu(&__perf_iommu, "amd_iommu");
>   
Linus, sorry for inconvenience.  This is a mistake in my part.

Peter, thank you for sending out the patch quickly.  I have checked the 
patch and this is okay.

Suravee


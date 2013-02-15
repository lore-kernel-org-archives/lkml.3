Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935603Ab3BOIs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:48:28 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39339 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3BOIs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:48:27 -0500
Message-ID: <511DF658.9080005@hitachi.com>
Date: Fri, 15 Feb 2013 17:48:24 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 2/2 v2] kexec: Export PG_hwpoison flag into vmcoreinfo
References: <508FDEF3.8030601@hitachi.com> <20121030143750.GF2290@redhat.com> <50913011.2030900@hitachi.com> <20130208174944.96a3b50952e45e1219a94819@mxc.nes.nec.co.jp>
In-Reply-To: <20130208174944.96a3b50952e45e1219a94819@mxc.nes.nec.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kumagai-san,

> I'm curious to know the status of this patch because I'll release
> makedumpfile-1.5.2 with the feature to exclude hwpoison page soon.

I requested Andrew to merge the kernel side patch, and the patch
has been added the -mm tree.

Please push the makedumpfile side patch into makedumpfile-1.5.2.

Regards,
Mitsuhiro Tanino

> TO: mm-commits@vger.kernel.org; 
> CC: mitsuhiro.tanino.gm@hitachi.com; ebiederm@xmission.com; vgoyal@redhat.com; 
> Sender: akpm@linux-foundation.org
> Sugject: + kexec-export-pg_hwpoison-flag-into-vmcoreinfo.patch added to -mm tree
> Date: 2013/02/13 07:50
> 
> 
> The patch titled
>      Subject: kexec: export PG_hwpoison flag into vmcoreinfo
> has been added to the -mm tree.  Its filename is
>      kexec-export-pg_hwpoison-flag-into-vmcoreinfo.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
> Subject: kexec: export PG_hwpoison flag into vmcoreinfo
> 
> This patch exports a PG_hwpoison into vmcoreinfo when
> CONFIG_MEMORY_FAILURE is defined.  "makedumpfile" needs to read
> information of memory, such as 'mem_section', 'zone', 'pageflags' from
> vmcore.
> 
> We introduce a function into "makedumpfile" to exclude hwpoison page from
> vmcore dump.  In order to introduce this function, PG_hwpoison flag have
> to export into vmcoreinfo.
> 
> Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/kexec.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff -puN kernel/kexec.c~kexec-export-pg_hwpoison-flag-into-vmcoreinfo kernel/kexec.c
> --- a/kernel/kexec.c~kexec-export-pg_hwpoison-flag-into-vmcoreinfo
> +++ a/kernel/kexec.c
> @@ -1537,6 +1537,9 @@ static int __init crash_save_vmcoreinfo_
>  	VMCOREINFO_NUMBER(PG_private);
>  	VMCOREINFO_NUMBER(PG_swapcache);
>  	VMCOREINFO_NUMBER(PG_slab);
> +#ifdef CONFIG_MEMORY_FAILURE
> +	VMCOREINFO_NUMBER(PG_hwpoison);
> +#endif
>  	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
>  
>  	arch_crash_save_vmcoreinfo();
> _
> 
> Patches currently in -mm which might be from mitsuhiro.tanino.gm@hitachi.com are
> 
> kexec-export-pg_hwpoison-flag-into-vmcoreinfo.patch




(2013/02/08 17:49), Atsushi Kumagai wrote:
> Hello,
> 
> On Wed, 31 Oct 2012 23:05:05 +0900
> Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com> wrote:
> 
>> This patch exports a PG_hwpoison into vmcoreinfo when
>> CONFIG_MEMORY_FAILURE is defined.
>> "makedumpfile" needs to read information of memory, such as
>> 'mem_section', 'zone', 'pageflags' from vmcore.
>>
>> We introduce a function into "makedumpfile" to exclude
>> hwpoison page from vmcore dump.
>> In order to introduce this function, PG_hwpoison flag have
>> to export into vmcoreinfo.
>>
>> Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
> 
> I'm curious to know the status of this patch because I'll release
> makedumpfile-1.5.2 with the feature to exclude hwpoison page soon.
> 
> 
> Thanks
> Atsushi Kumagai
> 
>> ---
>>  kernel/kexec.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>> index 0668d58..0d5d6bc 100644
>> --- a/kernel/kexec.c
>> +++ b/kernel/kexec.c
>> @@ -1513,6 +1513,9 @@ static int __init crash_save_vmcoreinfo_init(void)
>>         VMCOREINFO_NUMBER(PG_lru);
>>         VMCOREINFO_NUMBER(PG_private);
>>         VMCOREINFO_NUMBER(PG_swapcache);
>> +#ifdef CONFIG_MEMORY_FAILURE
>> +       VMCOREINFO_NUMBER(PG_hwpoison);
>> +#endif
>>
>>         arch_crash_save_vmcoreinfo();
>>         update_vmcoreinfo_note();
>> --
>> 1.7.10.1
>>
>> _______________________________________________
>> kexec mailing list
>> kexec@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/kexec
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> .
> 


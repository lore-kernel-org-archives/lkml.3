Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3BLDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 22:09:29 -0500
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:47957 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab3BLDJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 22:09:27 -0500
Message-ID: <5119B1E1.4010405@hitachi.com>
Date: Tue, 12 Feb 2013 12:07:13 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>, ebiederm@xmission.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH 2/2 v2] kexec: Export PG_hwpoison flag into vmcoreinfo
References: <508FDEF3.8030601@hitachi.com> <20121030143750.GF2290@redhat.com> <50913011.2030900@hitachi.com> <20130208174944.96a3b50952e45e1219a94819@mxc.nes.nec.co.jp>
In-Reply-To: <20130208174944.96a3b50952e45e1219a94819@mxc.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re: [Patch 0/2] Exclude hwpoison page from vmcore dump
(2012/11/01 19:40), Eric W. Biederman wrote:
> Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com> writes:
> I agree.  If we are performing filtering filtering out of poisoned pages
> seems very reasonable.  So ack on the basic concept.
> 
> Eric

Hello, Eric,

Could you please push the patch to export PG_hwpoison flag into 3.9 during
next merge window?

Kumagai-san acked the patch which provides the feature to exclude hwpoison
page and he will push the fix of makedumpfile side into makedumpfile-1.5.2.
This kernel patch is also required to enable this feature.

Regards,
Mitsuhiro Tanino


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


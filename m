Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab3BLK7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:59:19 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34125 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab3BLK7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:59:02 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        vgoyal@redhat.com, Andrew Morton <akpm@linux-foundation.org>
References: <508FDEF3.8030601@hitachi.com> <20121030143750.GF2290@redhat.com>
	<50913011.2030900@hitachi.com>
	<20130208174944.96a3b50952e45e1219a94819@mxc.nes.nec.co.jp>
	<5119B1E1.4010405@hitachi.com>
Date: Tue, 12 Feb 2013 02:58:50 -0800
In-Reply-To: <5119B1E1.4010405@hitachi.com> (Mitsuhiro Tanino's message of
	"Tue, 12 Feb 2013 12:07:13 +0900")
Message-ID: <8738x1hk7p.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18eXjka5WrVcm7jdLIbxtZxnC4kbo3dcH4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2 v2] kexec: Export PG_hwpoison flag into vmcoreinfo
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com> writes:

> Re: [Patch 0/2] Exclude hwpoison page from vmcore dump
> (2012/11/01 19:40), Eric W. Biederman wrote:
>> Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com> writes:
>> I agree.  If we are performing filtering filtering out of poisoned pages
>> seems very reasonable.  So ack on the basic concept.
>> 
>> Eric
>
> Hello, Eric,
>
> Could you please push the patch to export PG_hwpoison flag into 3.9 during
> next merge window?
>
> Kumagai-san acked the patch which provides the feature to exclude hwpoison
> page and he will push the fix of makedumpfile side into makedumpfile-1.5.2.
> This kernel patch is also required to enable this feature.

If Andrew hasn't already picked this up please send send a copy of the
patch through him.  Kexec related patches have historically gone through
Andrew after review.

Right now I don't have a kexec tree in linux-next and I don't have the
time/energy to start running one right now.

But I am happy to add my acked-by to the patch.  Exporting PG_hwpoison
seems entirely reasonable.

I thought I read somewhere upthread that Andrew had already picked this
patch up though?

Eric


> Regards,
> Mitsuhiro Tanino
>
>
> (2013/02/08 17:49), Atsushi Kumagai wrote:
>> Hello,
>> 
>> On Wed, 31 Oct 2012 23:05:05 +0900
>> Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com> wrote:
>> 
>>> This patch exports a PG_hwpoison into vmcoreinfo when
>>> CONFIG_MEMORY_FAILURE is defined.
>>> "makedumpfile" needs to read information of memory, such as
>>> 'mem_section', 'zone', 'pageflags' from vmcore.
>>>
>>> We introduce a function into "makedumpfile" to exclude
>>> hwpoison page from vmcore dump.
>>> In order to introduce this function, PG_hwpoison flag have
>>> to export into vmcoreinfo.
>>>
>>> Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
>> 
>> I'm curious to know the status of this patch because I'll release
>> makedumpfile-1.5.2 with the feature to exclude hwpoison page soon.
>> 
>> 
>> Thanks
>> Atsushi Kumagai
>> 
>>> ---

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>>>  kernel/kexec.c |    3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/kernel/kexec.c b/kernel/kexec.c
>>> index 0668d58..0d5d6bc 100644
>>> --- a/kernel/kexec.c
>>> +++ b/kernel/kexec.c
>>> @@ -1513,6 +1513,9 @@ static int __init crash_save_vmcoreinfo_init(void)
>>>         VMCOREINFO_NUMBER(PG_lru);
>>>         VMCOREINFO_NUMBER(PG_private);
>>>         VMCOREINFO_NUMBER(PG_swapcache);
>>> +#ifdef CONFIG_MEMORY_FAILURE
>>> +       VMCOREINFO_NUMBER(PG_hwpoison);
>>> +#endif
>>>
>>>         arch_crash_save_vmcoreinfo();
>>>         update_vmcoreinfo_note();
>>> --
>>> 1.7.10.1
>>>
>>> _______________________________________________
>>> kexec mailing list
>>> kexec@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/kexec
>> 
>> _______________________________________________
>> kexec mailing list
>> kexec@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/kexec
>> .
>> 

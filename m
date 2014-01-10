Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaAJD6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:58:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37531 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaAJD6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:58:33 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52CF6FBE.8000005@jp.fujitsu.com>
Date: Fri, 10 Jan 2014 12:57:50 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Prarit Bhargava <prarit@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] acpi memory hotplug, add parameter to disable memory
 hotplug for kexec
References: <1389220181-14474-1-git-send-email-prarit@redhat.com> <3476878.EqQiEtA2Ag@vostro.rjw.lan> <20140109150053.GD25897@redhat.com> <CAHGf_=oaPZNE8tVsZ1C1z3mHee8MK6CkuZ0YBTcJpRrTWgVn6g@mail.gmail.com> <20140109214425.GD12111@redhat.com>
In-Reply-To: <20140109214425.GD12111@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/10 6:44), Vivek Goyal wrote:
> On Thu, Jan 09, 2014 at 04:34:16PM -0500, KOSAKI Motohiro wrote:
>> On Thu, Jan 9, 2014 at 10:00 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>> On Thu, Jan 09, 2014 at 12:00:29AM +0100, Rafael J. Wysocki wrote:
>>>
>>> [..]
>>>>> The system then panics and the kdump/kexec kernel boots.  During this boot
>>>>> ACPi is initialized and the kernel (as can be seen above)
>>>>
>>>> Which is a bug.  You're not supposed to initialize ACPI twice in a row.
>>>
>>> [CC lkml, kexec mailing list, dave young]
>>>
>>> It is a fresh instance of kernel booting and it is initializing its data
>>> structures fresh. It is *not* re-initializing ACPI in same kernel.
>>>
>>>>> This patchset resolves the problem by adding a kernel parameter,
>>>>> no_memory_hotplug, to disable ACPI memory hotplug.  It can be added by default
>>>>> as a parameter to the kexec/kdump kernel so the kernel boots correctly.
>>>>
>>>> This problem is specific to kexec/kdump, so please don't add *generic* command
>>>> line parameters to address this.
>>>>
>>>
>>> There are other command line options to solve kdump problems. In general
>>> one might want to disable memory hogplug on the fly even if it is compiled
>>> in the kernel. So it can act as a good debugging aid.
>>>
>>> Secondly, it can be specified with memmap=exactmap and mem=X paramters to
>>> make sure no memory is hot added in the system.
>>>
>>> So I can see other usages of this parameter. To me it makes sense to have
>>> a separate command line option to disable memory hotplug feature on the
>>> fly.
>>
>> I'm ok this option. But note, even if this option is specified, SH,
>> Power and S390 still
>> be able to use memory hotplug because their firmware are totally
>> different from ACPI.
>>
>> Maybe, adding acpi prefix provides good clarification.
>

> Makes sense. Something like "acpi_no_memhotplug" or "acpi_disable_memhotplug"
> or something else.

I like Prarit's patch and the boot option name. If it is updated,
I'll test it.

Thanks,
Yasuaki Ishimatsu

>
> Thanks
> Vivek
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



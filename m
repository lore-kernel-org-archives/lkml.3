Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3H0Gxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:53:38 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:52976 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3H0Gxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <CANVTcTZT-0bg=GBdo06=1--NgyMEM6-pFX8DjMxh=7JYtaTLpw@mail.gmail.com>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
	<1376189294-32022-27-git-send-email-yinghai@kernel.org>
	<CANVTcTYhdiptB_sOUyveBfieg0VkTGdor16kCHKkJDemHzcWXw@mail.gmail.com>
	<CAE9FiQVSRMdinMKQdJUB_q8pAK-ei-Q-if+8K5yyz=HRTHbCTA@mail.gmail.com>
	<CANVTcTZT-0bg=GBdo06=1--NgyMEM6-pFX8DjMxh=7JYtaTLpw@mail.gmail.com>
Date: Mon, 26 Aug 2013 23:53:36 -0700
X-Google-Sender-Auth: hSRUn_fxfj7aEPHuAnnp5yP9m2M
Message-ID: <CAE9FiQVM+q=PjZ+Q_wR2-BGrbs+gBcGyKFhOqGZdZWyxjMjB0g@mail.gmail.com>
Subject: Re: [PATCH v4 26/28] PCI, x86, ACPI: Link acpi ioapic register to ioapic
From: Yinghai Lu <yinghai@kernel.org>
To: rui wang <ruiv.wang@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 11:44 PM, rui wang <ruiv.wang@gmail.com> wrote:
> On 8/27/13, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Fri, Aug 23, 2013 at 5:51 PM, rui wang <ruiv.wang@gmail.com> wrote:
>>> On 8/11/13, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> During ioapic hotplug, acpi_register_ioapic will be called.
>>>> Now for x86, that function is blank.
>>>> Fill that will update __mp_register_ioapic to use those ioapic.
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>> ---
>>>>  arch/x86/kernel/acpi/boot.c | 10 ++++++----
>>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
>>>> index 5be15d1..4a5336d 100644
>>>> --- a/arch/x86/kernel/acpi/boot.c
>>>> +++ b/arch/x86/kernel/acpi/boot.c
>>>> @@ -707,16 +707,18 @@ EXPORT_SYMBOL(acpi_unmap_lsapic);
>>>>
>>>>  int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32
>>>> gsi_base)
>>>>  {
>>>> -     /* TBD */
>>>> -     return -EINVAL;
>>>> +     unsigned long long id = 0;
>>>> +
>>>> +     acpi_evaluate_integer(handle, "_UID", NULL, &id);
>>>
>>> We cannot assume that "_UID" is an integer. "_UID" can be either an
>>> integer or a string. Need to consider the case when it is a string.
>>
>> Yes.
>>
>> But do you have test case for ioapic that _UID is not integer?
>>
>
> Yes I have an IOAPIC with an _UID of:
>
>         Name (_UID, "IOAPIC01")  // _UID: Unique ID
>
> It's a bit challenge how you'll conjure unique identifiers from both
> integers and strings. If you have a new patch I can help try it out.

Then do you have _MAT with that ioapic device or else?

need to find the _MAT entry with GSM matching to find out ioapic id.


Thanks

Yinghai

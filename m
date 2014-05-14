Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaENNLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:11:45 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44846 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaENNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:11:44 -0400
MIME-Version: 1.0
In-Reply-To: <53730504.4080201@amd.com>
References: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com> <53730504.4080201@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 14 May 2014 07:11:23 -0600
Message-ID: <CAErSpo4hRkDnRTnz1Ur7Fu8AwE4YFtZesUJebFEGi2ECSkdPag@mail.gmail.com>
Subject: Re: [PATCH V4 0/4] x86/pci Fix numa_node info for AMD hostbridge and
 misc clean up.
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, Robert Richter <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 11:54 PM, Suravee Suthikulpanit
<suravee.suthikulpanit@amd.com> wrote:
> Bjorn,
>
> I am following up on this patch set.  Do you have any other concerns?

Sorry, I've been busy with some other work and haven't had a chance to
look at this yet.

> On 05/08/2014 11:44 AM, suravee.suthikulpanit@amd.com wrote:
>>
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> This in the V4 of the patch set which trys to fixed up numa_node for AMD
>> hostbridges.
>> This topic was discussed in the following threads:
>>
>> V1: https://lkml.org/lkml/2014/3/5/898
>> V2: https://lkml.org/lkml/2014/4/18/623
>> V3: https://lkml.org/lkml/2014/5/7/588
>>
>> Change from V3:
>> Split up the changes in patch1 into two per Robert's suggestions. The
>> second patch has
>> no functional change.
>>
>> Change from V2:
>> As requested by Bjorn, the patch set will only add supports for family15h,
>> and
>> also deprecating the mechanism, as future platforms should be relying on
>> the ACPI info.
>> He has also requested to keep the changes to the minimum. Therefore, the
>> V2 patch 2 and 3
>> has been removed.
>>
>> Suravee Suthikulpanit (2):
>>    Patch1: x86/PCI: Fix PCI root numa_node info on AMD family15h
>>    Patch2: x86/PCI: Clean up and mark early_root_info_init as deprecated
>>
>> Myron Stowe (2):
>>    Patch3: ACPI/PCI: Warn if we have to "guess" host bridge node
>> information
>>    Patch4: X86/PCI: Remove unnecessary 'quirk_amd_nb_node'
>>
>>   arch/x86/kernel/quirks.c | 58 -------------------------------------
>>   arch/x86/pci/acpi.c      |  6 +++-
>>   arch/x86/pci/amd_bus.c   | 75
>> +++++++++++++++++++++++++++++-------------------
>>   3 files changed, 51 insertions(+), 88 deletions(-)
>>
>

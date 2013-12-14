Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3LNUuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:50:39 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44480 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab3LNUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6gy9ZMcv=2+aWbT1CeZ=1kkvu74eNgMrU1y4Nxs40eAw@mail.gmail.com>
References: <CAMxnaaWgUPRb3L2aKpUu62F73GR2iXOfd6LUnTkU0O=Gq-E_sQ@mail.gmail.com>
 <CAE9FiQUtqtBLx3_pdhs=CjgqViGrDL9xdCjLKgs66jA-apHdQA@mail.gmail.com>
 <CAMxnaaVEzSuEXRyX5KKKvUJFKTGikP_hfQddT6Ke7Dx6boOuKQ@mail.gmail.com> <CAErSpo6gy9ZMcv=2+aWbT1CeZ=1kkvu74eNgMrU1y4Nxs40eAw@mail.gmail.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Sat, 14 Dec 2013 21:50:17 +0100
Message-ID: <CAMxnaaXgJ9wcn62fMRWzoCaJ3T=NRnWFOphEEczw3_Z-ZPFxMw@mail.gmail.com>
Subject: Re: How to reserve pci bus numbers for hotplug?
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done: https://bugzilla.kernel.org/show_bug.cgi?id=67001

On Fri, Dec 13, 2013 at 6:09 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Dec 12, 2013 at 12:56 PM, Andreas Noever
> <andreas.noever@gmail.com> wrote:
>> On Thu, Dec 12, 2013 at 1:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Wed, Dec 11, 2013 at 3:37 PM, Andreas Noever
>>> <andreas.noever@gmail.com> wrote:
>>>
>>>> If I could get Linux to assign enough resources (bus numbers for now)
>>>> then I could drop the acpi_osi parameter and make thunderbolt work
>>>> after suspend... So, is there an easy way to fix this? (Quirks,
>>>> reconfiguring bus number assignments from a platform driver, ...?)
>>>
>>> please check if busn_alloc at
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>>> for-pci-busn-alloc-3.14
>>>
>>> could help.
>>
>> It seems to help. The initial assignment looks good:
>>            +-01.1-[05-9b]----00.0-[06-27]--+-00.0-[07]----00.0  Intel
>> Corporation DSL3510 Thunderbolt Port [Cactus Ridge]
>>            |                               +-03.0-[08-0f]--
>>            |                               +-04.0-[10-17]--
>>            |                               +-05.0-[18-1f]--
>>            |                               \-06.0-[20-27]--
>> After hotplug it looks like this:
>>            +-01.1-[05-9b]----00.0-[06-29]--+-00.0-[07]----00.0  Intel
>> Corporation DSL3510 Thunderbolt Port [Cactus Ridge]
>>            |
>> +-03.0-[08-11]----00.0-[09-11]----00.0-[0a-11]----00.0  Broadcom
>> Corporation NetXtreme BCM57762 Gigabit Ethernet PCIe
>>            |                               +-04.0-[10-17]--
>>            |                               +-05.0-[18-1f]--
>>            |                               \-06.0-[20-27]--
>> (Note that the bridge numbers are not disjoint)
>>
>> dmesg is attached.
>>
>> What is the status of the patch? Will it be merged for 3.14?
>
> It's not on my radar yet, so likely won't make it for v3.14.
>
> Can you open a report at http://bugzilla.kernel.org and attach
> complete dmesg logs without and with Yinghai's patches, and also the
> complete "lspci -vv" output?
>
> Bjorn

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3LMGEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:04:49 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:42308 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3LMGEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:04:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAMxnaaVEzSuEXRyX5KKKvUJFKTGikP_hfQddT6Ke7Dx6boOuKQ@mail.gmail.com>
References: <CAMxnaaWgUPRb3L2aKpUu62F73GR2iXOfd6LUnTkU0O=Gq-E_sQ@mail.gmail.com>
	<CAE9FiQUtqtBLx3_pdhs=CjgqViGrDL9xdCjLKgs66jA-apHdQA@mail.gmail.com>
	<CAMxnaaVEzSuEXRyX5KKKvUJFKTGikP_hfQddT6Ke7Dx6boOuKQ@mail.gmail.com>
Date: Thu, 12 Dec 2013 22:04:47 -0800
X-Google-Sender-Auth: KMm3M51Xu_x8LfU1zE0LUKVjQNU
Message-ID: <CAE9FiQWZMkYAsdPOohcYxc+wMuCwbXzyoHaDtKQ02gtJQyJTRQ@mail.gmail.com>
Subject: Re: How to reserve pci bus numbers for hotplug?
From: Yinghai Lu <yinghai@kernel.org>
To: Andreas Noever <andreas.noever@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:56 AM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> On Thu, Dec 12, 2013 at 1:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Wed, Dec 11, 2013 at 3:37 PM, Andreas Noever
>> <andreas.noever@gmail.com> wrote:
>>
>>> If I could get Linux to assign enough resources (bus numbers for now)
>>> then I could drop the acpi_osi parameter and make thunderbolt work
>>> after suspend... So, is there an easy way to fix this? (Quirks,
>>> reconfiguring bus number assignments from a platform driver, ...?)
>>
>> please check if busn_alloc at
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>> for-pci-busn-alloc-3.14
>>
>> could help.
>
> It seems to help. The initial assignment looks good:
>            +-01.1-[05-9b]----00.0-[06-27]--+-00.0-[07]----00.0  Intel
> Corporation DSL3510 Thunderbolt Port [Cactus Ridge]
>            |                               +-03.0-[08-0f]--
>            |                               +-04.0-[10-17]--
>            |                               +-05.0-[18-1f]--
>            |                               \-06.0-[20-27]--
> After hotplug it looks like this:
>            +-01.1-[05-9b]----00.0-[06-29]--+-00.0-[07]----00.0  Intel
> Corporation DSL3510 Thunderbolt Port [Cactus Ridge]
>            |
> +-03.0-[08-11]----00.0-[09-11]----00.0-[0a-11]----00.0  Broadcom
> Corporation NetXtreme BCM57762 Gigabit Ethernet PCIe
>            |                               +-04.0-[10-17]--
>            |                               +-05.0-[18-1f]--
>            |                               \-06.0-[20-27]--
> (Note that the bridge numbers are not disjoint)
>
> dmesg is attached.
>
> What is the status of the patch? Will it be merged for 3.14?
>

We may use your test case to ask Linus to reconsider to include busn_alloc
patchset.

Thanks

Yinghai

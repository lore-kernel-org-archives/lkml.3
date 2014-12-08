Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaLHX74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:59:56 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58018 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbaLHX7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:59:55 -0500
MIME-Version: 1.0
In-Reply-To: <1418079372.13358.9.camel@kernel.crashing.org>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
	<1418079372.13358.9.camel@kernel.crashing.org>
Date: Mon, 8 Dec 2014 15:59:54 -0800
X-Google-Sender-Auth: 0ntHFWQ16b7_zAxt7ZLMtrFsDMY
Message-ID: <CAE9FiQX-vMu5+Kr09ngr95WvtoZTUSL5R2+NiVFeiN6q-BXLLg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 2:56 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2014-12-08 at 13:52 -0800, Yinghai Lu wrote:
>> 2. or scan the children resource other than ROM to clear bridge MEM_64
>>    for mmio pref.
>>
>> The patch is using second way so will keep child mmio pref into bridge
>> mmio pref range.
>
> That means that having a single ROM BAR that is 32-bit and prefetchable
> will downgrade the entire window to 32-bit ? That's not going to work
> either.

the ROM BAR get skipped during the checking.

+                       if (i != PCI_ROM_RESOURCE)
+                               mem64_mask &= r->flags & IORESOURCE_MEM_64;
+               }

>
> I have GPUs with 16G BARs for example... suddenly they don't fit
> anaymore because we downgraded the window to 32 bit because somewhere
> there's a 32-bit pref resource ?
>
> That will break more than it fixes...

Please check if this patch break your platform. I tried on my setup on
x86. and it is still
working on 64 bit resource allocation.

Thanks

Yinghai

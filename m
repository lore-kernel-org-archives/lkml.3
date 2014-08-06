Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaHFTFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:05:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43383 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaHFTFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:05:50 -0400
Message-ID: <53E27C7B.80200@ti.com>
Date: Wed, 6 Aug 2014 15:05:31 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: keystone: add a pci quirk to limit mrrs
References: <1407338300-9146-1-git-send-email-m-karicheri2@ti.com> <20140806163021.GB19914@obsidianresearch.com> <53E25E24.8070506@ti.com> <20140806165837.GC19914@obsidianresearch.com> <53E26155.1020107@ti.com> <20140806173014.GD19914@obsidianresearch.com>
In-Reply-To: <20140806173014.GD19914@obsidianresearch.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 01:30 PM, Jason Gunthorpe wrote:
> On Wed, Aug 06, 2014 at 01:09:41PM -0400, Murali Karicheri wrote:
>
>>>> Yes it works with tuning enabled. Tuning happens afterwards. The
>>>> 'limiting mrrs to 256' below is from my patch.
>>>
>>> That seems backwards to me...
>> Rational? The tuning is reading mrrs and set mps to less than or
>> equal to mrss. So adding this before make sure mrrs used is below
>> keystones's limit.
>
> The tuning process adjusts the parameters however it sees fit, todays
> algorithm might not increase a BIOS set MRRS, but tomorrow's could.
>
> The quirk should be after the tuning to ensure the MRRS is limited..
>
> Jason
Ok. I see it.

The latest possible quirk application point seems to be before enabling
the ep device. A change in macro as below will achieve this and it works.

-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_mrrs);
+DECLARE_PCI_FIXUP_ENABLE(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_mrrs);

If this looks reasonable, I will repost my patch with this change.

regards,

Murali

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3ENKCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:02:20 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59725 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab3ENKCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:02:16 -0400
Message-ID: <51920B8E.4020101@mev.co.uk>
Date: Tue, 14 May 2013 11:01:50 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130410 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] staging: comedi: ni_labpc: fix VIRT_TO_BUS dependency
References: <5190B62C.1070704@mev.co.uk> <1368442935-25926-1-git-send-email-abbotti@mev.co.uk> <20130513212837.GB14092@kroah.com>
In-Reply-To: <20130513212837.GB14092@kroah.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-05-13 22:28, Greg Kroah-Hartman wrote:
> On Mon, May 13, 2013 at 12:02:15PM +0100, Ian Abbott wrote:
>> The "ni_labpc" module acts as a low-level comedi driver for various
>> Nattional Instruments Lab-PC ISA cards if `CONFIG_NI_LABPC_ISA` is
>> enabled, and also as a common module depended on by the "ni_labpc_cs"
>> and "ni_labpc_pci" modules.  For ISA cards, it optionally supports the
>> use of an ISA DMA channel if `CONFIG_ISA_DMA_API` is enabled, using
>> conditionally compiled code.  This conditionally compiled code also
>> relies on `virt_to_bus()`, which only exists if `CONFIG_VIRT_TO_BUS` is
>> enabled.  Therefore, support for ISA DMA should only be compiled in if
>> both `CONFIG_ISA_DMA_API` and `CONFIG_VIRT_TO_BUS` are defined,
>> otherwise the "ni_labpc" module fails to compile on kernels that enable
>> `CONFIG_ISA_DMA_API` but not `CONFIG_VIRT_TO_BUS`.
>>
>> Conditionally define a new macro `NI_LABPC_ISA_DMA` iff both
>> `CONFIG_ISA_DMA_API` and `CONFIG_VIRT_TO_BUS` are defined, and change
>> the conditional compilation tests to use the new macro instead of
>> `CONFIG_ISA_DMA_API`.
>>
>> Also, in the "Kconfig", remove the `VIRT_TO_BUS` dependency from the
>> `COMEDI_NI_LABPC_ISA` option since the dependency is now checked at
>> compile time.
>>
>> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
>> ---
>>   drivers/staging/comedi/Kconfig            |  1 -
>>   drivers/staging/comedi/drivers/ni_labpc.c | 18 +++++++++++-------
>>   2 files changed, 11 insertions(+), 8 deletions(-)
>
> Ick, no, I'll take Hartley's patch he sent a week or so ago that fixes
> this properly for all architectures.

Okay, I completely forgot about that patch!  I think the Kconfig part of 
my patch is still valid though, so I'll repost that part.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

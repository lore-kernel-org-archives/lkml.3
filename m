Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbbASUar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:30:47 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:39045 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbbASUao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:30:44 -0500
MIME-Version: 1.0
In-Reply-To: <54BD580C.6030701@gmail.com>
References: <1421681040-3392-1-git-send-email-aleksey.makarov@auriga.com>
 <20150119154357.GH21553@leverpostej> <54BD580C.6030701@gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 19 Jan 2015 14:30:22 -0600
Message-ID: <CAL_JsqKq22K3kk7m09J1GZn9xXB+0tCUe75u3x+S3oWC0kyDcw@mail.gmail.com>
Subject: Re: [PATCH] SATA: OCTEON: support SATA on OCTEON platform
To: David Daney <ddaney.cavm@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Vinita Gupta <vgupta@caviumnetworks.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 1:16 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 01/19/2015 07:43 AM, Mark Rutland wrote:
>>
>> On Mon, Jan 19, 2015 at 03:23:58PM +0000, Aleksey Makarov wrote:
>>>
>>> The OCTEON SATA controller is currently found on cn71XX devices.

[...]

>>> +
>>> +       /* Set a good dma_mask */
>>> +       pdev->dev.coherent_dma_mask = DMA_BIT_MASK(64);
>>> +       pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
>>
>>
>> I thought a dma-ranges property in the DT could be used to set up the
>> DMA mask appropriately?
>
>
> The DT contains no dma-ranges property, and we know a priori, that it should
> be 64-bits.

Neither this code nor dma-ranges should be necessary. The AHCI core
code will set the mask to 32 or 64 bits based on the AHCI Capabilities
register.

Rob

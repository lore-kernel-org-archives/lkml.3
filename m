Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaHFOji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:39:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45552 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbaHFOjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:39:36 -0400
Message-ID: <53E23DDB.4010803@ti.com>
Date: Wed, 6 Aug 2014 10:38:19 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Richard Zhu <r65037@freescale.com>,
        Marek Vasut <marex@denx.de>, Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-pci@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        <linux-kernel@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 4/5] PCI: add PCI controller for keystone PCIe h/w
References: <1405961925-27248-1-git-send-email-m-karicheri2@ti.com> <1405961925-27248-5-git-send-email-m-karicheri2@ti.com> <20140722223527.GA27965@google.com> <53CEEB1C.9020202@ti.com> <20140722235200.GC27965@google.com> <20140723174228.GB11270@obsidianresearch.com> <53D948D4.6080603@ti.com> <20140730200513.GA11918@obsidianresearch.com>
In-Reply-To: <20140730200513.GA11918@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 04:05 PM, Jason Gunthorpe wrote:
> On Wed, Jul 30, 2014 at 03:34:44PM -0400, Murali Karicheri wrote:
>
>> • Maximum remote read request size of 256 bytes
>
> The PCI spec simply does not permit a completer to impose this
> limitation.
>
> See spec 2.3.1.1
>
> It is not an option to error a read request because it is too
> long. All requests must be completed. All completions must be segmented
> according to the RCB and Max_Payload_Size.
>
>> completion packets. So it seems to be able to segment up to maximum
>> 256 bytes of read request. Where do I find the requirement in PCI
>> spec that "read response segmentation at the host bridge does not
>> work" ?
>
> You just said it. Segmenting up to only 256 bytes is not a limitation
> the completer can impose. Such a device is non-conformant.
>
>>> So, the only fix is that every downstream device must always have a
>>> MRSS set to less than the MPS of the host bridge.
>>
>> Why this can't be the default behavior in the PCI core? Any cons?
>
> It increases read request traffic and read response latency on the bus
> for large transfers.
>
> The MRSS is intented as a performance tuning knob, it is not something
> that ever needs to be set properly for correct bus operation.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Jason, Bjorn,

It appears that Keystone PCI has a hardware limitation that can't
handle read request size of greater than 256 bytes and a quirk is the
way to handle this hardware limitation. I will be sending a patch to
address this

Murali


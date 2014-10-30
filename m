Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbaJ3SiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:38:20 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:39998 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbaJ3SiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:38:19 -0400
Message-ID: <54528595.8070009@imgtec.com>
Date: Thu, 30 Oct 2014 11:38:13 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-mips@linux-mips.org>, <nbd@openwrt.org>, <yanh@lemote.com>,
        <linux-kernel@vger.kernel.org>, <ralf@linux-mips.org>,
        <alex.smith@imgtec.com>, <taohl@lemote.com>, <chenhc@lemote.com>,
        <blogic@openwrt.org>
Subject: Re: [PATCH] MIPS: DMA: fix coherent alloc in non-coherent systems
References: <20141030014753.13189.48344.stgit@linux-yegoshin> <54520DE4.9090008@imgtec.com>
In-Reply-To: <54520DE4.9090008@imgtec.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 03:07 AM, James Hogan wrote:
> Hi Leonid,
>
> On 30/10/14 01:48, Leonid Yegoshin wrote:
>> A default dma_alloc_coherent() fails to alloc a coherent memory on non-coherent
>> systems in case of device->coherent_dma_mask covering the whole memory space.
>>
>> In case of non-coherent systems the coherent memory on MIPS is restricted by
>> size of un-cachable segment and should be located in ZONE_DMA.
> Has this pretty much always been broken?
>
>
Yes, but it can be seen on MIPS32 EVA-based CPUs.

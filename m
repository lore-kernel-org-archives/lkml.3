Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab3A3LFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:05:04 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:38007 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab3A3LEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:04:49 -0500
Message-ID: <5108FDEA.20206@synopsys.com>
Date: Wed, 30 Jan 2013 15:03:06 +0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd.bergmann@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <Vineet.Gupta1@synopsys.com>, <benh@kernel.crashing.org>,
        <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201301291627.34913.arnd.bergmann@linaro.org>
In-Reply-To: <201301291627.34913.arnd.bergmann@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.121.8.102]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 08:27 PM, Arnd Bergmann wrote:
> On Tuesday 29 January 2013, Alexey Brodkin wrote:
>> in(out)_8/in(out)_be16/in(out)_le16 are very powerpc/microblaze
>> specific. To enable use of Xilinx System ACE driver build for other
>> architectures (for example it's possible to use it on Xilinx ml-509
>> board with ARC700 in FPGA) we need to use generic implementation of
>> accessors.
>>
>> Current implementation was successfully built with Sourcery G++ Lite
>> 2011.03-39 for Power EABI (ppc44x_defconfig).
>>
>> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
>
> Is this driver used on powerpc64 as well, or just on microblaze
> and/or 32 bit powerpc?
>
> On 64 bit powerpc, ioread involves extra overhead because it
> goes through the PCI error handling implementation, so we should
> keep using in_le() there.	
>
> 	Arnd
>

Personally I have no idea about usage of the named device on powerpc64.
Wondering if anybody may comment on this?

My only intention was to make the driver portable.
Do you think if there's another generic alternative for originally used 
accessors?

For example will it be better with "readb/readw/writeb/writew"?

-Alexey

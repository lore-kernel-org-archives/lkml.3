Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3IZKMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:12:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45399 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab3IZKMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:12:44 -0400
Message-ID: <5244088B.20807@ti.com>
Date: Thu, 26 Sep 2013 15:42:27 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Pratyush Anand <pratyush.anand@st.com>, Jingoo Han <jg1.han@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
References: <000701ce8741$fe47deb0$fad79c10$@samsung.com> <201309242323.55323.arnd@arndb.de> <5243C0E5.7020508@ti.com> <201309261151.42034.arnd@arndb.de>
In-Reply-To: <201309261151.42034.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thursday 26 September 2013 03:21 PM, Arnd Bergmann wrote:
> On Thursday 26 September 2013, Kishon Vijay Abraham I wrote:
>> On Wednesday 25 September 2013 02:53 AM, Arnd Bergmann wrote:
>>> On Monday 23 September 2013, Kishon Vijay Abraham I wrote:
>>>> Btw if we hadn't programmed inbound translation table, the address will go
>>>> untranslated (according to the data book). I guess that's how it was working
>>>> for Jingoo Han.
>>>>
>>>> **
>>>> 3.10.4
>>>> Inbound iATU Operation
>>>>
>>>> When there is no match, then the address is untranslated
>>>> **
>>>>
>>>
>>> Well, that should work just as well, since you have a 1:1 translation anyway.
>>> Do you get the same error without the translation?
>>
>> Yes. I get the same non-fatal error interrupt in RC.
> 
> Ok, then I guess the translation is actually not at fault here but something
> else. I would recommend looking at the IOMMU as the potential culprit. Maybe
> having it disabled means that no DMA is going through, rather than all DMA
> going through untranslated. Another possibility is that the IOMMU is set up
> so that when disabled, it maps DMA address 0 to the start of RAM, rather
> than identity mapping DMA address 0x80000000 there. If that's the case,
> you either have to use the IOMMU, or set up the mapping in the root
> complex to revert it.

Thanks for your inputs. I'll check if that's the problem.

Thanks
Kishon

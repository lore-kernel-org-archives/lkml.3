Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3FEOnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:43:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53640 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3FEOno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:43:44 -0400
Message-ID: <51AF4E9D.3050109@codeaurora.org>
Date: Wed, 05 Jun 2013 10:43:41 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 5/6] arm64/xen: introduce CONFIG_XEN and hypercall.S
 on ARM64
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com> <1370434530-22428-5-git-send-email-stefano.stabellini@eu.citrix.com> <1471793.18ZhhAHKN9@wuerfel> <20130605125051.GB11402@mudshark.cambridge.arm.com>
In-Reply-To: <20130605125051.GB11402@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 06/05/2013 08:50 AM, Will Deacon wrote:
> On Wed, Jun 05, 2013 at 01:44:55PM +0100, Arnd Bergmann wrote:
>> On Wednesday 05 June 2013 13:15:29 Stefano Stabellini wrote:
>>> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
>>> index c95c5cb..79dd13d 100644
>>> --- a/arch/arm64/Makefile
>>> +++ b/arch/arm64/Makefile
>>> @@ -37,6 +37,7 @@ TEXT_OFFSET := 0x00080000
>>>  export TEXT_OFFSET GZFLAGS
>>>  
>>>  core-y         += arch/arm64/kernel/ arch/arm64/mm/
>>> +core-$(CONFIG_XEN)             += arch/arm64/xen/
>>>  libs-y         := arch/arm64/lib/ $(libs-y)
>>>  libs-y         += $(LIBGCC)
>>>  
>>> diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
>>> new file mode 100644
>>> index 0000000..be24040
>>> --- /dev/null
>>> +++ b/arch/arm64/xen/Makefile
>>> @@ -0,0 +1,2 @@
>>> +xen-arm-y      += $(addprefix ../../arm/xen/, enlighten.o grant-table.o)
>>> +obj-y          := xen-arm.o hypercall.o
>>
>> I think it would be nicer to redirect the entire directory, not just
>> the enlighten.o and grant-table.o files. You could do in arch/arm64/Makefile:
>>
>> core-(CONFIG_XEN) += arch/arm/xen/
>>
>> That leaves a small difference in hypercall.o, which I think you can
>> handle with an #ifdef.
>>
>> I believe the reason why KVM does the more elaborate variant is that
>> they want to be able to build their code as a loadable module that
>> also includes code from virt/kvm, which you don't need.
> 
> I thought we scrapped the idea of KVM as a loadable module on ARM, mainly
> due to the complexities with retrospective initialisation of HYP mode/EL2?

What if Hyp/EL2 support were dubbed regular kernel code and the rest of KVM
was made loadable?

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.

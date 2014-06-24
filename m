Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965515AbaFXQKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:10:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58473 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965173AbaFXQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:10:15 -0400
Message-ID: <53A9A290.7020407@ti.com>
Date: Tue, 24 Jun 2014 12:08:48 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Marek Vasut <marex@denx.de>, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ABRAHAM KISHON VIJAY <kishon@ti.com>,
        Richard Zhu <r65037@freescale.com>, Rob Herring <robh+dt@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
References: <20140623053249.GD2666@pratyush-vbox> <53A85ACE.9070506@ti.com>
In-Reply-To: <53A85ACE.9070506@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pratyush,

On 06/23/2014 12:50 PM, Santosh Shilimkar wrote:
>
>
>
> -------- Original Message --------
> Subject: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
> On Sat, Jun 21, 2014 at 03:05:30AM +0800, Arnd Bergmann wrote:
>> On Friday 20 June 2014 13:11:37 Santosh Shilimkar wrote:
>
>>>>
>>> Arnd suggestion was to have the version 3.65 code in generic place since
>>> its IP specific and just in case some other vendor using the same version
>>> can leverage the code.
>
> Sorry, I do not follow PCIe mailing list these days, doing something else
> now. So coming to this topic a bit delayed.
>
My Apologies for the email format as I mysteriously lost this email and
had to resort to a forwarded email to respond to this.

Let us have the discussion on this thread as I lost the original emails.
>>>
>>> Concern here seems toe really those name of the files. I can't think of
>>> any other appropriate name.
>>
>> We should definitely keep the version in the DT "compatible" strings
>> wherever we know it. Regarding a better file name, I have no idea.
>
> In my opinion, we do not need any of dw-v3_65 files, as code in these
> files will not be usable by other vendors.
>
> Anything which is implemented in application space, will not be same
> across all IP users. For example, MSI0_IRQ_ENABLE_SET has been defined
> at offset 0x108 in keystone PCIe application space.Other vendor may
> not have this register at the same offset. Moreover, other vendors are
> not even obliged to implement MSI Enable signals in same way, so
> internal bit definition of the register may change.
>
> Therefore code is not reusable if all register offset and bit
> definitions are not same across vendors. So, in case of DW driver none
> of the code which are accessed using va_app_base should go to common
> area.
>

I think based on the response far on this issue, it is best to keep
the Application specific code as part of Keystone driver and in
future if there is any driver that has similar application register
implemented. we can refactor the code and re-use.

My V3 will revert back to implementation similar to RFC. Also since this
is individual h/w specific, there is no no need for a compatibility as
well. Will use keystone specific compatibility string for this.

Arnd, hope this is fine. Please respond if you still think a 
compatibility string is needed.

Murali

> Pratyush
>
>>
>> 	Arnd
>
>


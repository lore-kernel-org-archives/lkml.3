Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaFWFeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 01:34:15 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:33207 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbaFWFeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 01:34:13 -0400
Date: Mon, 23 Jun 2014 11:02:49 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Marek Vasut <marex@denx.de>, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Richard Zhu <r65037@freescale.com>, Rob Herring <robh+dt@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
Message-ID: <20140623053249.GD2666@pratyush-vbox>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
 <53A453D1.4040308@ti.com>
 <53A46B49.3040009@ti.com>
 <14956334.eDhb2zObBc@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <14956334.eDhb2zObBc@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-22_03:2014-06-20,2014-06-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 03:05:30AM +0800, Arnd Bergmann wrote:
> On Friday 20 June 2014 13:11:37 Santosh Shilimkar wrote:

> > > 
> > Arnd suggestion was to have the version 3.65 code in generic place since
> > its IP specific and just in case some other vendor using the same version
> > can leverage the code.

Sorry, I do not follow PCIe mailing list these days, doing something else
now. So coming to this topic a bit delayed.

> > 
> > Concern here seems toe really those name of the files. I can't think of
> > any other appropriate name. 
> 
> We should definitely keep the version in the DT "compatible" strings
> wherever we know it. Regarding a better file name, I have no idea.

In my opinion, we do not need any of dw-v3_65 files, as code in these
files will not be usable by other vendors.

Anything which is implemented in application space, will not be same
across all IP users. For example, MSI0_IRQ_ENABLE_SET has been defined
at offset 0x108 in keystone PCIe application space.Other vendor may
not have this register at the same offset. Moreover, other vendors are
not even obliged to implement MSI Enable signals in same way, so
internal bit definition of the register may change.
      
Therefore code is not reusable if all register offset and bit
definitions are not same across vendors. So, in case of DW driver none
of the code which are accessed using va_app_base should go to common
area.

Regards
Pratyush

> 
> 	Arnd

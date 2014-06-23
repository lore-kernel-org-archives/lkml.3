Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaFWFP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 01:15:29 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:45401 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbaFWFPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 01:15:18 -0400
Date: Mon, 23 Jun 2014 10:43:46 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
Message-ID: <20140623051346.GC2666@pratyush-vbox>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
 <2CC2A0A4A178534D93D5159BF3BCB6619C5F8169D1@EAPEX1MAIL1.st.com>
 <53A4A4D3.1000908@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53A4A4D3.1000908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-22_03:2014-06-20,2014-06-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 05:17:07AM +0800, Murali Karicheri wrote:
> 
> Sorry, my previous response was in html and not sure it has made to the 
> list. I did
> get an error as well. So resending my response.
> 
> On 6/18/2014 6:14 AM, Mohit KUMAR DCG wrote:
> > Hello Murali,
> >
> 

[...]

> *pos = pos0;
> 
> @@ -349,7 +353,10 @@ static int dw_msi_setup_irq(struct msi_chip *chip, 
> struct pci_dev *pdev,
> 
> */
> 
> desc->msi_attrib.multiple = msgvec;
> 
> -msg.address_lo = virt_to_phys((void *)pp->msi_data);
> 
> +if (pp->ops->get_msi_data)
> 
> +msg.address_lo = pp->ops->get_msi_data(pp);
> 
> +else
> 
> +msg.address_lo = virt_to_phys((void *)pp->msi_data);
> 
> msg.address_hi = 0x0;
> 
> msg.data = pos;
> 
> 
> What about this code? This requires get_msi_data() as well

pp->msi_data is set in dw_pcie_msi_init, which is a global function
called from vendor specific code. You can have your own
keystone_pcie_msi_init and then you do not need above changes.

> 
> > -- 3rd to use pp->ops->msi_set/clear if defined.
> Why not API enhancement and refactor the code in a single patch?

Yes, can be. You can send changes in 2 or 3 patches as you wish, but I
believe that should be able to solve problem in best way.

Regards
Pratyush
> 
> Murali
> > Pls let us know for any issue or have different opinion.
> >
> > Regards
> > Mohit
> >
> >
> >
> >   
> >> --
> >> 1.7.9.5
> 

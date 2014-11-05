Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaKEK27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:28:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:7280 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbaKEK2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:28:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,319,1413270000"; 
   d="scan'208";a="602641667"
Message-ID: <5459FBDD.4020504@linux.intel.com>
Date: Wed, 05 Nov 2014 18:28:45 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch Part2 v4 00/31] Enable hierarchy irqdomian on x86 platforms
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com> <20141104144730.GE14512@8bytes.org> <5458ECF3.4040308@linux.intel.com> <20141105085154.GG10744@8bytes.org> <5459F0DE.6000307@linux.intel.com> <20141105095850.GH10744@8bytes.org>
In-Reply-To: <20141105095850.GH10744@8bytes.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,
	Seems like a silly bug, could you please help to try this
fix?
Regards!
Gerry
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 7423ee16972f..62ba8a6f6e79 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1211,7 +1211,7 @@ int msi_irq_domain_alloc_irqs(struct irq_domain
*domain, int type,
                                msidesc->nvec_used > 1) ?  1 : -ENOSPC;
                }
                for (i = 0; i < msidesc->nvec_used; i++)
-                       irq_set_msi_desc_off(virq + i, i, msidesc);
+                       irq_set_msi_desc_off(virq, i, msidesc);
        }

        list_for_each_entry(msidesc, &dev->msi_list, list)

On 2014/11/5 17:58, Joerg Roedel wrote:
> On Wed, Nov 05, 2014 at 05:41:50PM +0800, Jiang Liu wrote:
>> 	Could you please help to apply the attached patch and send me
>> console outputs?
> 
> Sure, here it is.
> 

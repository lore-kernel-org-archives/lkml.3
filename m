Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaIRI7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:59:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:54445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbaIRI7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:59:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,546,1406617200"; 
   d="scan'208";a="604685500"
Message-ID: <541A9EAB.3060000@linux.intel.com>
Date: Thu, 18 Sep 2014 16:58:19 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Joe.C" <srv_yingjoe.chen@mediatek.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Part2 v1 01/21] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>	 <1410444228-3134-2-git-send-email-jiang.liu@linux.intel.com> <1411030087.14746.2.camel@mtksdaap41>
In-Reply-To: <1411030087.14746.2.camel@mtksdaap41>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/18 16:48, Joe.C wrote:
> On Thu, 2014-09-11 at 22:03 +0800, Jiang Liu wrote:
>> +#else	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
>> +static inline int irq_domain_activate_irq(struct irq_data *data) { return 0; }
>> +static inline int irq_domain_deactivate_irq(struct irq_data *data) { return 0; }
>> +#endif	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
>> +
> 
> I get the following build warnings on these lines:
> 
> ../include/linux/irqdomain.h:75:47: warning: 'struct irq_data' declared
> inside parameter list [enabled by default]
> ../include/linux/irqdomain.h:75:47: warning: its scope is only this
> definition or declaration, which is probably not what you want [enabled
> by default]
> ../include/linux/irqdomain.h:76:49: warning: 'struct irq_data' declared
> inside parameter list [enabled by default
Hi Joe,
	Thanks for testing. We should add a forward declaration of
struct irq_data to the top of include/linux/irqdomain.h.
Will fix it in next version.
Regards!
Gerry
> 
> Joe.C
> 
> 

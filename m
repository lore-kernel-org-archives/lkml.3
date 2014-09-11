Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaIKIpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:45:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:19726 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbaIKIp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:45:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="601339986"
Message-ID: <54116106.5090904@linux.intel.com>
Date: Thu, 11 Sep 2014 16:44:54 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Ask help about pre_init_apic_IRQ0()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

When converting IOAPIC to hierarchy irqdomain, I ran into trouble when
dealing with pre_init_apic_IRQ0(). Currently pre_init_apic_IRQ0() is
only used by intel-mid platform and is called before initializing of
IOAPIC irqdomains. That really causes headache when converting to
hierarchy irqdomain. So could we delay
	io_apic_setup_irq_pin(0, 0, &attr);
        irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
                                      "edge");
to the point of "check_timer()"?

I have no MID hardware at handle so can't experiment with it. Could
you please refer someone for help?

/* Enable IOAPIC early just for system timer */
void __init pre_init_apic_IRQ0(void)
{
        struct io_apic_irq_attr attr = { 0, 0, 0, 0 };

        printk(KERN_INFO "Early APIC setup for system timer0\n");
#ifndef CONFIG_SMP
        physid_set_mask_of_physid(boot_cpu_physical_apicid,
                                         &phys_cpu_present_map);
#endif
        setup_local_APIC();

        io_apic_setup_irq_pin(0, 0, &attr);
        irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
                                      "edge");
}

Regards!
Gerry

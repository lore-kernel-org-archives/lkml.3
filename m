Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaE1Kjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:39:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:34243 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaE1Kju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:39:50 -0400
Message-ID: <5385BCD0.1080802@linutronix.de>
Date: Wed, 28 May 2014 12:39:12 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch V3 19/37] x86, irq: introduce mechanisms to support dynamically
 allocate IRQ for IOAPIC
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com> <1401178092-1228-20-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.02.1405271445050.21720@ionos.tec.linutronix.de> <538597F0.1040003@linutronix.de> <alpine.DEB.2.02.1405281159030.21720@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405281159030.21720@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 12:07 PM, Thomas Gleixner wrote:
> 
> Right, so it needs the setup of irq 0 and that only happens when the
> legacy_pic->nr_legacy_irqs > 0.
>
> Do you remember, why we switch to the null_pic later on?

According to my memory all interrupts are serviced by the IOAPIC. The
first 16 by the first IOAPIC, 17+ (everything behind the "PCI-bus") by
the second IOAPIC. For that reason I didn't see a reason for the legacy
PIC and set it to null_pic. Due to the timer problem it is delayed.

> Thanks,
> 
> 	tglx

Sebastian

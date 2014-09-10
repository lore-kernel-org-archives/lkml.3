Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaIJUId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:08:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:35822 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaIJUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:08:31 -0400
Date: Wed, 10 Sep 2014 22:08:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch v4 14/16] x86, irq: Introduce helper to check whether an
 IOAPIC has been registered
In-Reply-To: <540FBB93.4020509@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409102206300.4178@nanos>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com> <1409192561-19744-15-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1409091433150.11037@nanos> <540FBB93.4020509@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Jiang Liu wrote:
> On 2014/9/9 20:37, Thomas Gleixner wrote:
> >> +	ret  = mp_ioapic_registered(gsi_base);
> >> +	up_write(&acpi_ioapic_rwsem);
> >> +
> >> +	return ret;
> >> +}
> > 
> > So I assume that this is for a particular caller in the apci ioapic
> > hotplug code and that call site has its own serialization. Otherwise
> > the return value is not protected at all.
> > 
> > Please add a Docbook comment to that function, and document the
> > locking rules as thats pretty non obvious.
> How about this comments about locking rules?
> /*
>  * Locks related to IOAPIC hotplug
>  * Hotplug side:
>  *      ->lock_device_hotplug() //device_hotplug_lock
>  *              ->acpi_ioapic_rwsem
>  *                      ->ioapic_lock
>  * Interrupt mapping side:
>  *      ->acpi_ioapic_rwsem
>  *              ->ioapic_mutex
>  *                      ->ioapic_lock
>  */

That looks asymetric. Why is the hotplug side not taking ioapic_mutex?

Thanks,

	tglx

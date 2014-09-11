Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaIKOsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:48:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:41048 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaIKOsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:48:10 -0400
Date: Thu, 11 Sep 2014 16:47:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC Part1 v1 07/18] x86, irq: Introduce helpers to access struct
 irq_cfg
In-Reply-To: <alpine.DEB.2.10.1409111126410.4178@nanos>
Message-ID: <alpine.DEB.2.10.1409111647000.4178@nanos>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com> <1410423905-26239-8-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.10.1409111126410.4178@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Thomas Gleixner wrote:
> On Thu, 11 Sep 2014, Jiang Liu wrote:
> > -static inline struct irq_cfg *irq_cfg(unsigned int irq)
> > +struct irq_cfg *irq_cfg(unsigned int irq)
> >  {
> >  	return irq_get_chip_data(irq);
> >  }
> >  
> > +struct irq_cfg *irqd_cfg(struct irq_data *irq_data)
> > +{
> > +	return irq_data->chip_data;
> > +}
> 
> We can make those inlines. There is no point to have that as global
> functions.

Never mind. Just reading the other patch set.....

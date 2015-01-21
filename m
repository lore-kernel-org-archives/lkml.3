Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbbAUJoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:44:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:53306 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbAUJoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:44:34 -0500
Date: Wed, 21 Jan 2015 10:43:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Thierry Reding <treding@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [RFC Patch 17/19] resources: Move struct resource_list_entry
 from ACPI into resource core
In-Reply-To: <54BF4911.7030906@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1501211043170.5526@nanos>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-18-git-send-email-jiang.liu@linux.intel.com> <3428063.tN1BxOoXSN@vostro.rjw.lan> <54BF4911.7030906@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Jiang Liu wrote:
> On 2015/1/21 9:10, Rafael J. Wysocki wrote:
> >> +
> >> +void resource_list_insert(struct list_head *head,
> >> +			  struct resource_list_entry *entry, bool tail)
> > 
> > I would call this resource_list_add() if anything.
> > 
> > Also it may be better to have two helpers, one for "add" and one for "add_tail"
> > (and perhaps define them as static inline?).
> We can't use inline functions here because that needs pulling list.h
> into ioport.h, then causing building issues to header inclusion order.

Create a new header file to avoid the circular dependencies then.

Thanks,

	tglx

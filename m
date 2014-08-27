Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaH0IFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:05:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:52734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaH0IFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:05:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="593878323"
Date: Wed, 27 Aug 2014 11:04:42 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Bugfix] x86, irq: Fix bug in setting IOAPIC pin attributes
Message-ID: <20140827080238.GH1785@lahna.fi.intel.com>
References: <20140826095221.GO1660@lahna.fi.intel.com>
 <1409118795-17046-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409118795-17046-1-git-send-email-jiang.liu@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 01:53:11PM +0800, Jiang Liu wrote:
> Commit 15a3c7cc9154321fc3 "x86, irq: Introduce two helper functions
> to support irqdomain map operation" breaks LPSS ACPI enumerated
> devices.
> 
> On startup, IOAPIC driver preallocates IRQ descriptors and programs
> IOAPIC pins with default level and polarity attributes for all legacy
> IRQs. Later legacy IRQ users may fail to set IOAPIC pin attributes
> if the requested attributes conflicts with the default IOAPIC pin
> attributes. So change mp_irqdomain_map() to allow the first legacy IRQ
> user to reprogram IOAPIC pin with different attributes.
> 
> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
> Hi Mika,
> 	We have a plan to kill function mp_set_gsi_attr() later, so
> I have slightly modified your changes. Could you please help to test
> it again?

Works fine here, thanks!

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

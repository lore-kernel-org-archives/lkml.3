Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaEICu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:50:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaEICuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:50:25 -0400
Date: Fri, 9 May 2014 04:50:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3 2/4] DMA-API: Change dma_declare_coherent_memory() CPU
 address to phys_addr_t
Message-ID: <20140509025014.GE21085@kroah.com>
References: <20140508204257.17877.4639.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140508204900.17877.3108.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508204900.17877.3108.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 02:49:00PM -0600, Bjorn Helgaas wrote:
> dma_declare_coherent_memory() takes two addresses for a region of memory: a
> "bus_addr" and a "device_addr".  I think the intent is that "bus_addr" is
> the physical address a *CPU* would use to access the region, and
> "device_addr" is the bus address the *device* would use to address the
> region.
> 
> Rename "bus_addr" to "phys_addr" and change its type to phys_addr_t.
> Most callers already supply a phys_addr_t for this argument.  The others
> supply a 32-bit integer (a constant, unsigned int, or __u32) and need no
> change.
> 
> Use "unsigned long", not phys_addr_t, to hold PFNs.
> 
> No functional change (this could theoretically fix a truncation in a config
> with 32-bit dma_addr_t and 64-bit phys_addr_t, but I don't think there are
> any such cases involving this code).
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

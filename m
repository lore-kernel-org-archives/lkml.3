Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaEAAGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:06:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEAAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:06:53 -0400
Date: Wed, 30 Apr 2014 17:07:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU
 address to phys_addr_t
Message-ID: <20140501000750.GB21775@kroah.com>
References: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 02:33:21PM -0600, Bjorn Helgaas wrote:
> dma_declare_coherent_memory() takes two addresses for a region of memory: a
> "bus_addr" and a "device_addr".  I think the intent is that "bus_addr" is
> the physical address a *CPU* would use to access the region, and
> "device_addr" is the bus address the *device* would use to address the
> region.
> 
> Rename "bus_addr" to "phys_addr" and change its type to phys_addr_t.

Isn't this going to cause problems with the callers of this function?
You aren't changing them...

greg k-h

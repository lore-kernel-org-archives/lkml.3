Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaCDRUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:20:21 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:18828 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaCDRUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:20:19 -0500
Message-ID: <53160B51.90309@tilera.com>
Date: Tue, 4 Mar 2014 12:20:17 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] tile PCI RC: Use default pcibios_enable_device()
References: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140226234208.18970.41395.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226234208.18970.41395.stgit@bhelgaas-glaptop.roam.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/2014 6:42 PM, Bjorn Helgaas wrote:
> We don't need anything arch-specific in pcibios_enable_device(), so drop
> the arch implementation and use the default generic one.
>
> Note: pci_enable_resources() checks that r->parent is non-NULL, which
> basically checks that pci_claim_resource() or request_resource() has been
> called for each BAR.  I don't see where that happens for tile, but this
> patch doesn't change that behavior, so if it worked before, it should still
> work.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/kernel/pci_gx.c |   12 ------------
>  1 file changed, 12 deletions(-)
>

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaHFQa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:30:28 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:58322 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaHFQa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:30:26 -0400
Date: Wed, 6 Aug 2014 10:30:21 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH] PCI: keystone: add a pci quirk to limit mrrs
Message-ID: <20140806163021.GB19914@obsidianresearch.com>
References: <1407338300-9146-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407338300-9146-1-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 11:18:20AM -0400, Murali Karicheri wrote:
> Keystone PCI controller has a limitation that memory read request
> size must not exceed 256 bytes. This is a hardware limitation and
> add a quirk to force this limit on all downstream devices by
> updating mrrs.

Does this still work if the tuning is enabled, or does the tuning run
after this?

> +			if (pcie_get_readrq(dev) > 256) {
> +				pr_info("limiting mrrs to 256\n");
> +				pcie_set_readrq(dev, 256);

The pr_info should either go away, or at least print the PCI bdf..

Jason

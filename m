Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaBJKWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:22:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaBJKWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:22:00 -0500
Message-ID: <1392027718.2082.11.camel@linux-fkkt.site>
Subject: Re: [PATCH part1 v5 3/7] PCI: Add support for Device Serial Number
 capability
From: Oliver Neukum <oneukum@suse.de>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Paul Bolle <pebolle@tiscali.nl>, "RafaelJ.Wysocki" <rjw@rjwysocki.net>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Mon, 10 Feb 2014 11:21:58 +0100
In-Reply-To: <1392005051-54508-4-git-send-email-wangyijing@huawei.com>
References: <1392005051-54508-1-git-send-email-wangyijing@huawei.com>
	 <1392005051-54508-4-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2014-02-10 at 12:04 +0800, Yijing Wang wrote:
> +static u64 pci_device_serial_number(struct pci_bus *bus, int devfn)
> +{
> +       int pos;
> +       u32 lo, hi;
> +
> +       if (!pci_bus_find_capability(bus, devfn, PCI_CAP_ID_EXP))
> +               return 0;
> +
> +       pos = pci_bus_find_ext_capability(bus, devfn,
> PCI_EXT_CAP_ID_DSN);
> +       if (!pos)
> +               return 0;
> +
> +       pci_bus_read_config_dword(bus, devfn, pos + 4, &lo);
> +       pci_bus_read_config_dword(bus, devfn, pos + 8, &hi);

We have no macro for that?

> +       return ((u64)hi << 32) | lo;
> +}

	Regards
		Oliver




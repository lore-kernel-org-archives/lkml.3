Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3BRMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 07:25:56 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53074 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3BRMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 07:25:55 -0500
Date: Mon, 18 Feb 2013 13:25:49 +0100
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>,
        wency@cn.fujitsu.com
Subject: Re: [PATCH] ACPI / scan: Make it clear that acpi_bus_trim() cannot
 fail
Message-ID: <20130218122549.GA4448@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1511096.zmfmBrfdmu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511096.zmfmBrfdmu@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 24, 2013 at 11:56:50PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since acpi_bus_trim() cannot fail, change its definition to a void
> function, so that its callers don't check the return value in vain
> and update the callers.

I have missed a few patchsets/discussions in the last month and wanted to
ask a question related to this: Does the new always-succeed 2-pass
trim_device design guarantee safe memory hot-remove operations?

Afaict if memory offline fails now, the device is ejected (_EJ0) anyways
causing a panic. Tested in a VM with linux-next-20130207 and
linux-next-20130218 by doing an SCI-eject request on a hot-plugged dimm.

Are there more patches in development for safe memory hot-remove?

thanks,

- Vasilis

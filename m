Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaGHTPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:15:48 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:45776 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbaGHTPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:15:45 -0400
Date: Tue, 8 Jul 2014 21:15:40 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <819511949.20140708211540@eikelenboom.it>
To: konrad@kernel.org
CC: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] Xen PCIbackend support for slot and bus reset (v3).
In-Reply-To: <1404845909-13563-1-git-send-email-konrad@kernel.org>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tuesday, July 8, 2014, 8:58:22 PM, you wrote:

> These patches had been posted in the past and had been reworked
> to address reviews. The original concerns with the patches was
> the complex logic of doing an workqueue (or thread) that would
> do the FLR/bus/slot reset outside the PCI lock. That idea proved
> buggy. The other idea of usurping the 'reset' SysFS didn't work
> either - as the the generic code will complain loudly about this.

> The best so far mechanism is to use the 'xl' toolstack usage
> of 'do_flr' and make that work in Xen pciback.

>  Documentation/ABI/testing/sysfs-driver-pciback |   95 ++++++++++++++
>  drivers/xen/xen-pciback/pci_stub.c             |  163 +++++++++++++++++++-----
>  drivers/xen/xen-pciback/xenbus.c               |    2 +-
>  3 files changed, 224 insertions(+), 36 deletions(-)

> Konrad Rzeszutek Wilk (7):
>       xen-pciback: Document the various parameters and attributes in SysFS
>       xen/pciback: Don't deadlock when unbinding.
>       xen/pciback: Move the FLR code to a function.
>       xen/pciback: Implement PCI reset slot or bus with 'do_flr' SysFS attribute
>       xen/pciback: Include the domain id if removing the device whilst still in use
>       xen/pciback: Print out the domain owning the device.
>       xen/pciback: Remove tons of dereferences

Could you push these to your kernel.org git tree ?

--
Sander




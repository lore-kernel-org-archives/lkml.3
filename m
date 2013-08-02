Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3HBWtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:49:51 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64885 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab3HBWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:49:48 -0400
MIME-Version: 1.0
In-Reply-To: <1375478934.15999.33.camel@pasglop>
References: <1375395497.31262.271.camel@ul30vt.home> <1375420202.3743.97.camel@pasglop>
 <1375461387.31262.314.camel@ul30vt.home> <1375478934.15999.33.camel@pasglop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 2 Aug 2013 16:49:27 -0600
Message-ID: <CAErSpo42yK=K55J30V3xd_Ki6KEUOU6q7sUpNrAYe517=CdiDA@mail.gmail.com>
Subject: Re: RFC: vfio-pci API for PCI bus/slot (hot) resets
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Fri, Aug 2, 2013 at 3:28 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:

> Right. Another use case is, I know of devices that need a fundamental
> reset (PERST) after applying a FW update.

This is a tangent from the real discussion here, but the question of
resetting a device after a firmware update concerns me.  Many if not
all of our current reset interfaces save & restore the architected
parts of config space around the reset.  But a reset after a firmware
update may change things like the number and type of BARs or even the
functionality of the device, so I don't think the restore is safe in
general.

I doubt this is a big problem in general, but I have found reports of
people having to do a system reset or reboot after updating, e.g.,
FPGA images.  I suppose at least some of these could be worked around
with the right hotplug incantations.

http://forums.xilinx.com/t5/PCI-Express/PC-is-hung-if-run-the-second-program-FPGA-by-JTAG/td-p/20871
http://www.alteraforum.com/forum/archive/index.php/t-28477.html
http://www.alteraforum.com/forum/showthread.php?t=35091
https://github.com/NetFPGA/NetFPGA-public/wiki/Restore-PCIE-Configuration
http://lkml.indiana.edu/hypermail/linux/kernel/1104.3/02544.html

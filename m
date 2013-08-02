Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3HBXQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:16:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:35665 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab3HBXQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:16:20 -0400
Message-ID: <1375485348.15999.66.camel@pasglop>
Subject: Re: RFC: vfio-pci API for PCI bus/slot (hot) resets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Sat, 03 Aug 2013 09:15:48 +1000
In-Reply-To: <CAErSpo42yK=K55J30V3xd_Ki6KEUOU6q7sUpNrAYe517=CdiDA@mail.gmail.com>
References: <1375395497.31262.271.camel@ul30vt.home>
	 <1375420202.3743.97.camel@pasglop> <1375461387.31262.314.camel@ul30vt.home>
	 <1375478934.15999.33.camel@pasglop>
	 <CAErSpo42yK=K55J30V3xd_Ki6KEUOU6q7sUpNrAYe517=CdiDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 16:49 -0600, Bjorn Helgaas wrote:
> [+cc linux-pci]
> 
> On Fri, Aug 2, 2013 at 3:28 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> 
> > Right. Another use case is, I know of devices that need a fundamental
> > reset (PERST) after applying a FW update.
> 
> This is a tangent from the real discussion here, but the question of
> resetting a device after a firmware update concerns me.  Many if not
> all of our current reset interfaces save & restore the architected
> parts of config space around the reset.  But a reset after a firmware
> update may change things like the number and type of BARs or even the
> functionality of the device, so I don't think the restore is safe in
> general.

Right.

> I doubt this is a big problem in general, but I have found reports of
> people having to do a system reset or reboot after updating, e.g.,
> FPGA images.  I suppose at least some of these could be worked around
> with the right hotplug incantations.

Yes.

We have that similar issue with error handling, when the driver doesn't
have the right hooks, we simulate an unplug, reset, then replug.

Maybe we could provide generic helpers to do that...

Cheers,
Ben.

> http://forums.xilinx.com/t5/PCI-Express/PC-is-hung-if-run-the-second-program-FPGA-by-JTAG/td-p/20871
> http://www.alteraforum.com/forum/archive/index.php/t-28477.html
> http://www.alteraforum.com/forum/showthread.php?t=35091
> https://github.com/NetFPGA/NetFPGA-public/wiki/Restore-PCIE-Configuration
> http://lkml.indiana.edu/hypermail/linux/kernel/1104.3/02544.html
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



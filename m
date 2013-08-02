Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3HBXhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:37:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab3HBXhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:37:37 -0400
Message-ID: <1375486647.31262.351.camel@ul30vt.home>
Subject: Re: RFC: vfio-pci API for PCI bus/slot (hot) resets
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Fri, 02 Aug 2013 17:37:27 -0600
In-Reply-To: <1375485348.15999.66.camel@pasglop>
References: <1375395497.31262.271.camel@ul30vt.home>
	 <1375420202.3743.97.camel@pasglop> <1375461387.31262.314.camel@ul30vt.home>
	 <1375478934.15999.33.camel@pasglop>
	 <CAErSpo42yK=K55J30V3xd_Ki6KEUOU6q7sUpNrAYe517=CdiDA@mail.gmail.com>
	 <1375485348.15999.66.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-03 at 09:15 +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2013-08-02 at 16:49 -0600, Bjorn Helgaas wrote:
> > [+cc linux-pci]
> > 
> > On Fri, Aug 2, 2013 at 3:28 PM, Benjamin Herrenschmidt
> > <benh@kernel.crashing.org> wrote:
> > 
> > > Right. Another use case is, I know of devices that need a fundamental
> > > reset (PERST) after applying a FW update.
> > 
> > This is a tangent from the real discussion here, but the question of
> > resetting a device after a firmware update concerns me.  Many if not
> > all of our current reset interfaces save & restore the architected
> > parts of config space around the reset.  But a reset after a firmware
> > update may change things like the number and type of BARs or even the
> > functionality of the device, so I don't think the restore is safe in
> > general.
> 
> Right.
> 
> > I doubt this is a big problem in general, but I have found reports of
> > people having to do a system reset or reboot after updating, e.g.,
> > FPGA images.  I suppose at least some of these could be worked around
> > with the right hotplug incantations.
> 
> Yes.
> 
> We have that similar issue with error handling, when the driver doesn't
> have the right hooks, we simulate an unplug, reset, then replug.
> 
> Maybe we could provide generic helpers to do that...

Devices going away and coming back is pretty difficult for vfio to
handle.  Perhaps helpers to rescan a device in-place would be easier.
On the QEMU side we'd need to rescan the device after each reset, which
would be rather tedious for the typical case where it doesn't change.
Thanks,

Alex


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaEDKkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 06:40:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaEDKko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 06:40:44 -0400
Message-ID: <1399200049.4302.3.camel@localhost.localdomain>
Subject: Re: [PATCH] PCI/shpchp: fix a bus speed issue on hotplug
From: Marcel Apfelbaum <marcel.a@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew@wil.cx>, "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 04 May 2014 13:40:49 +0300
In-Reply-To: <CAErSpo6SOc-OPQDyjweAataRXwjPYgXM3+P1nhK7zQ2vRjRE2g@mail.gmail.com>
References: <1398954948-24219-1-git-send-email-marcel.a@redhat.com>
	 <CAErSpo4KLq7m8PXzAEhv20e29Wk=sAtageDf3CgziDLno0JUCw@mail.gmail.com>
	 <1398968025.18595.22.camel@localhost.localdomain>
	 <1398970625.18595.24.camel@localhost.localdomain>
	 <CAErSpo6SOc-OPQDyjweAataRXwjPYgXM3+P1nhK7zQ2vRjRE2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-01 at 14:00 -0600, Bjorn Helgaas wrote:
> On Thu, May 1, 2014 at 12:57 PM, Marcel Apfelbaum
> <marcel.apfelbaum@gmail.com> wrote:
> > On Thu, 2014-05-01 at 21:13 +0300, Marcel Apfelbaum wrote:
> >> On Thu, 2014-05-01 at 12:02 -0600, Bjorn Helgaas wrote:
> >> > On Thu, May 1, 2014 at 8:35 AM, Marcel Apfelbaum <marcel.a@redhat.com> wrote:
> >> > > When a board is added, the shpchp driver checks if there
> >> > > is a mismatch between the bridge's adapter and the bus speed.
> >> > > If there is, it sets the subordinate speed (if there is no device on it).
> >> > >
> >> > > However, it takes the reference of the board speed from the primary bus
> >> > > and not from the subordinate. If the primary bus is PCI and not PCIX/PCIe,
> >> > > its speed is not updated and remains 0xff. As a result hotplug fails
> >> > > with error: "Speed of bus ff and adapter 0 mismatch".
> >> >
> >> > It'd be cool to have a bugzilla for this with lspci and dmesg output.
> >> > I'll also have to check the other hotplug drivers for similar issues,
> >> > unless you've already done that.
> >> I'll open a BZ with the details, sure.
> > Done: https://bugzilla.kernel.org/show_bug.cgi?id=75251
> > If you need further details, please let me know.
> 
> Thanks.  Would you mind attaching the "lspci -vv" output?  That should
> show more details, including the information used to compute the bus
> speed.
> 
> Also, you checked the "regression" box.  Can you confirm that and
> identify a known-working kernel?  If we know which kernels are broken,
> we can potentially mark the fix to be backported to them.
I checked 2.6.24-26-generic that comes with Ubuntu 8.04 and it works OK.
So we have a working version.

I hope it helps,
Marcel

> 
> Bjorn




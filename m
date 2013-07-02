Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3GBUkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:40:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56966 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab3GBUkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:40:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/6] PCI: acpiphp: do not check for SLOT_ENABLED in enable_device()
Date: Tue, 02 Jul 2013 22:49:50 +0200
Message-ID: <2243397.l6uQhQpZPo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130702203117.GT9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com> <4523014.G6VJLhZf81@vostro.rjw.lan> <20130702203117.GT9294@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 02, 2013 11:31:17 PM Mika Westerberg wrote:
> On Tue, Jul 02, 2013 at 10:29:12PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, July 02, 2013 10:40:39 AM Bjorn Helgaas wrote:
> > > On Mon, Jul 1, 2013 at 7:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Monday, July 01, 2013 09:36:13 PM Mika Westerberg wrote:
> > > >> On Mon, Jul 01, 2013 at 04:01:37PM +0200, Rafael J. Wysocki wrote:
> > > >> > > Given the fact that SLOT_ENABLED is only checked in acpiphp_enable_slot()
> > > >> > > (after this patch) and that /sys/bus/pci/slots/*/power uses SLOT_POWEREDON
> > > >> > > anyway, should we remove the whole flag?
> > > >> >
> > > >> > Sure, if it is not necessary any more, we should remove it.
> > > >>
> > > >> Well, there is one thing that changes due that. Once the flag is gone
> > > >> userspace can do 'echo 1 > /sys/bus/pci/slots/*/power' several times and
> > > >> the slot is always re-enumerated.
> > > >>
> > > >> If that is not acceptable we should probably move the SLOT_ENABLED check
> > > >> closer to acpiphp_core:enable_device() and drop it from here, so that we
> > > >> always re-enumerate on Bus Check event but userspace can only do enable
> > > >> once (we still re-enumerate on Bus Check).
> > > >
> > > > Yes, that sounds like the right thing to do.
> > > 
> > > Is it actually a problem if we re-enumerate every time userspace does
> > > 'echo 1 > /sys/bus/pci/slots/*/power'?  I assume re-enumeration is a
> > > no-op if nothing has changed.
> > 
> > Well, if it's a no-op in that case, then re-enumerating shouldn't be a problem,
> > but is it a no-op?
> 
> I can confirm that it's a no-op (at least for the Thunderbolt case).
> Basically we just scan for new devices and nothing is to be found.

We can try to drop SLOT_ENABLED entirely then I suppose.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3LQW0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:26:52 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54047 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3LQW0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:26:50 -0500
MIME-Version: 1.0
In-Reply-To: <1387318331.30327.16.camel@bling.home>
References: <20131210183339.26294.14581.stgit@bling.home> <20131210184845.26294.81385.stgit@bling.home>
 <20131217004815.GA4781@google.com> <1387318331.30327.16.camel@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 17 Dec 2013 15:26:29 -0700
Message-ID: <CAErSpo71MGrddm-T3xzU685adsgWc0O+gcK6JEoPtVbAAMztdA@mail.gmail.com>
Subject: Re: [PATCH 3/3] pci: Add Virtual Channel to save/restore support
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 3:12 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2013-12-16 at 17:48 -0700, Bjorn Helgaas wrote:
>> On Tue, Dec 10, 2013 at 11:48:45AM -0700, Alex Williamson wrote:

>> > +static void pci_vc_load_arb_table(struct pci_dev *dev, int pos)
>> > +{
>> > +   u32 ctrl;
>> > +
>> > +   pci_read_config_dword(dev, pos + PCI_VC_PORT_CTRL, &ctrl);
>> > +   pci_write_config_dword(dev, pos + PCI_VC_PORT_CTRL, ctrl | 1);
>> > +   if (pci_wait_for_pending(dev, pos + PCI_VC_PORT_STATUS, 1))

>> spec says these are 16-bit registers; shouldn't these be "word" accesses?
>
> The control registers are 32-bit, the status registers are 16-bit.
> pci_wait_for_pending uses word access.

The "VC Resource Control Registers" at offset 14h + (n * 0Ch) are 32
bits, but I was referring to the PCI_VC_PORT_CTRL accesses (sorry I
didn't make that clear).  I'm looking at 7.11.4 "Port VC Control
Register" at offset 12 (0Ch), and that one looks like 16 bits to me.

Bjorn

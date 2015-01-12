Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbbALAFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 19:05:15 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:58582 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbbALAFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 19:05:13 -0500
MIME-Version: 1.0
In-Reply-To: <4938579.0KIk3QtTCP@wuerfel>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
	<1420857290-8373-8-git-send-email-robh@kernel.org>
	<CACRpkdbwKN9LenqrWeu4WykhdZOGAdxpC_BYr2cYpc2_cn5GfA@mail.gmail.com>
	<4938579.0KIk3QtTCP@wuerfel>
Date: Mon, 12 Jan 2015 01:05:12 +0100
Message-ID: <CACRpkdZSXWrVudiadVjbhQDS_zQrYttaytW-TUoeFUrc=beD1A@mail.gmail.com>
Subject: Re: [PATCH 07/16] ARM: integrator: convert PCI to use generic config accesses
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 10:53 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 10 January 2015 22:40:22 Linus Walleij wrote:
>> >  static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
>> >                           int size, u32 *val)
>> >  {
>> > -       addr = v3_open_config_window(bus, devfn, where);
>> > +       int ret = pci_generic_config_read(bus, devfn, where, size, val);
>> >         v3_close_config_window();
>> > +       return ret;
>> >  }
>> >
>> >  static int v3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
>> >                            int size, u32 val)
>> >  {
>> > +       int ret = pci_generic_config_write(bus, devfn, where, size, val);
>> >         v3_close_config_window();
>> > -       raw_spin_unlock_irqrestore(&v3_lock, flags);
>> > +       return ret;
>> >  }
>> >
>> >  static struct pci_ops pci_v3_ops = {
>> > +       .map_bus = v3_open_config_window,
>> >         .read   = v3_read_config,
>> >         .write  = v3_write_config,
>>
>> So .map_bus is called before every .read/.write operation I take it.
>>
>> Wouldn't it be proper to call the v3_close_config_window() from a
>> matching .unmap_bus() callback for symmetry?
>
> It would be nicer for integrator but useless for anything else, so
> I'd vote for leaving it the way Rob posted.

OK I buy that, throw in a comment about it in the code if there
is some time for iterating the patch.

Yours,
Linus Walleij

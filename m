Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbaDICvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:51:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:51205 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbaDICvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:51:42 -0400
Message-ID: <1397011868.3671.94.camel@pasglop>
Subject: Re: driver skip pci_set_master, fix it? No.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mark Lord <mlord@pobox.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Wed, 09 Apr 2014 12:51:08 +1000
In-Reply-To: <5344679E.1030008@pobox.com>
References: <5344251D.7040805@pobox.com>
	 <CAErSpo6KuYLaoEsxR4jJQ98P23kNEMzMcu_-RyM3nWd6YRxgag@mail.gmail.com>
	 <5344679E.1030008@pobox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 17:18 -0400, Mark Lord wrote:
> > I assume you're talking about the one added by cf3e1feba7f9 ("PCI:
> > Workaround missing pci_set_master in pci drivers"), but as far as I
> > can tell, it only calls pci_set_master() for *bridge* devices.  What
> > am I missing?  Is pci_set_master() being called for your endpoint?
> > What path is that?
> 
> Yes, it is being called during execution of the _probe() function in my driver,
> as evidenced by the annoying (and wrong) message it produces.
> 
> Next time I've got the hardware at hand, I'll put a "dump_stack()" into there
> to see the exact calling path.

Note that one of the reason we want to do it early on bridges is that without it,
we may also not get the PCIe error messages.

Cheers,
Ben.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3HSWnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:43:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:42559 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3HSWnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:43:01 -0400
Message-ID: <1376952167.25016.85.camel@pasglop>
Subject: Re: [PATCH] vfio-pci: PCI hot reset interface
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 20 Aug 2013 08:42:47 +1000
In-Reply-To: <CAErSpo50ve+ZMqcX=13hKvrB75LyWmUddC-qyX7Esfr=P5StcA@mail.gmail.com>
References: <20130814200845.21923.64284.stgit@bling.home>
	 <CAErSpo4zfuaaBSDci4jOu_9RgUfLQNPvKhro1OEh=8AMvAFWYw@mail.gmail.com>
	 <1376521578.13642.65.camel@ul30vt.home>
	 <1376937682.2657.15.camel@ul30vt.home>
	 <CAErSpo50ve+ZMqcX=13hKvrB75LyWmUddC-qyX7Esfr=P5StcA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 14:02 -0600, Bjorn Helgaas wrote:
> I guess.  And supply the pci_slot rather than the pci_dev?  I'm a
> little bit worried because the idea of a "slot" is not well-defined in
> the spec, and we have sort of an ad hoc method of discovering and
> managing them, e.g., acpiphp and pciehp might discover the same slot.
> But I guess that's no reason to bury generic code in vfio.

And I don't have pci_slot's at all yet on powerpc "powernv" (the host
platform for KVM) since at this stage we don't support physical hotplug
on the target machines...

Alex, why specifically looking for "slots" here ? I don't quite
understand. It makes sense to be able to reset individual devices
whether they are on the otherboard, behind extension chassis or directly
on slots...

Cheers,
Ben.
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab3HSXCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab3HSXCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:02:49 -0400
Message-ID: <1376953365.2657.36.camel@ul30vt.home>
Subject: Re: [PATCH] vfio-pci: PCI hot reset interface
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 19 Aug 2013 17:02:45 -0600
In-Reply-To: <1376952280.25016.87.camel@pasglop>
References: <20130814200845.21923.64284.stgit@bling.home>
	 <CAErSpo4zfuaaBSDci4jOu_9RgUfLQNPvKhro1OEh=8AMvAFWYw@mail.gmail.com>
	 <1376521578.13642.65.camel@ul30vt.home>
	 <1376937682.2657.15.camel@ul30vt.home>
	 <CAErSpo50ve+ZMqcX=13hKvrB75LyWmUddC-qyX7Esfr=P5StcA@mail.gmail.com>
	 <1376943632.2657.25.camel@ul30vt.home> <1376952280.25016.87.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 08:44 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-08-19 at 14:20 -0600, Alex Williamson wrote:
> > I try to handle the slot as opaque, only caring that the slot pointer
> > matches, so I think our implementation is ok... so long as we only get
> > one driver claiming to manage a slot, but that's not a vfio problem ;)
> > Thanks,
> 
> By why bother with slots ? Why do you even think about slots in that
> context ? slots are a badly defined thing in our current PCI stack,
> pretty much intricated with hotplug. I don't see why the reset semantics
> would be tied to slots at all.

See my other reply, hotplug presence detection and secondary bus resets
don't just work.

> The only case where it *might* make some sense (and even then ...) is if
> you want to start exposing slot power control and PERST but that would
> imply a pile of platform specific gunk anyway.

But that platform specific gunk can be hidden away in the hotplug
controller.  We just need to be able to ask if it can reset a slot and
tell it to do it.  If it happens via a slot power control or a secondary
bus reset, do we care?  Thanks,

Alex


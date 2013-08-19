Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3HSWou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:44:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:42570 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3HSWos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:44:48 -0400
Message-ID: <1376952280.25016.87.camel@pasglop>
Subject: Re: [PATCH] vfio-pci: PCI hot reset interface
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 20 Aug 2013 08:44:40 +1000
In-Reply-To: <1376943632.2657.25.camel@ul30vt.home>
References: <20130814200845.21923.64284.stgit@bling.home>
	 <CAErSpo4zfuaaBSDci4jOu_9RgUfLQNPvKhro1OEh=8AMvAFWYw@mail.gmail.com>
	 <1376521578.13642.65.camel@ul30vt.home>
	 <1376937682.2657.15.camel@ul30vt.home>
	 <CAErSpo50ve+ZMqcX=13hKvrB75LyWmUddC-qyX7Esfr=P5StcA@mail.gmail.com>
	 <1376943632.2657.25.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 14:20 -0600, Alex Williamson wrote:
> I try to handle the slot as opaque, only caring that the slot pointer
> matches, so I think our implementation is ok... so long as we only get
> one driver claiming to manage a slot, but that's not a vfio problem ;)
> Thanks,

By why bother with slots ? Why do you even think about slots in that
context ? slots are a badly defined thing in our current PCI stack,
pretty much intricated with hotplug. I don't see why the reset semantics
would be tied to slots at all.

The only case where it *might* make some sense (and even then ...) is if
you want to start exposing slot power control and PERST but that would
imply a pile of platform specific gunk anyway.

Ben.



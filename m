Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3BEOvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:51:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab3BEOvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:51:32 -0500
Message-ID: <1360075887.11144.554.camel@bling.home>
Subject: Re: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for
 VFIO-PCI devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>,
        Blue Swirl <blauwirbel@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 05 Feb 2013 07:51:27 -0700
In-Reply-To: <20130205134233.GK23213@redhat.com>
References: <F9E001219150CB45BEDC82A650F360C9014AAF07@G9W0717.americas.hpqcorp.net>
	 <CAAu8pHvk_2Mf2F-YTDC-wdyD1Jic-DHUanSQfOa3g0VchTcNig@mail.gmail.com>
	 <20130205080436.GV23213@redhat.com>
	 <F9E001219150CB45BEDC82A650F360C9014B42EE@G9W0717.americas.hpqcorp.net>
	 <20130205092110.GB23213@redhat.com>
	 <F9E001219150CB45BEDC82A650F360C9014B43DC@G9W0717.americas.hpqcorp.net>
	 <20130205113645.GE23213@redhat.com>
	 <F9E001219150CB45BEDC82A650F360C9014B445B@G9W0717.americas.hpqcorp.net>
	 <1360071455.11144.552.camel@bling.home> <20130205134233.GK23213@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 15:42 +0200, Gleb Natapov wrote:
> On Tue, Feb 05, 2013 at 06:37:35AM -0700, Alex Williamson wrote:
> > On Tue, 2013-02-05 at 12:05 +0000, Pandarathil, Vijaymohan R wrote:
> > > 
> > > > -----Original Message-----
> > > > From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
> > > > owner@vger.kernel.org] On Behalf Of Gleb Natapov
> > > > Sent: Tuesday, February 05, 2013 3:37 AM
> > > > To: Pandarathil, Vijaymohan R
> > > > Cc: Blue Swirl; Alex Williamson; Bjorn Helgaas; Ortiz, Lance E;
> > > > kvm@vger.kernel.org; qemu-devel@nongnu.org; linux-pci@vger.kernel.org;
> > > > linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for VFIO-
> > > > PCI devices
> > > > 
> > > > On Tue, Feb 05, 2013 at 10:59:41AM +0000, Pandarathil, Vijaymohan R wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Gleb Natapov [mailto:gleb@redhat.com]
> > > > > > Sent: Tuesday, February 05, 2013 1:21 AM
> > > > > > To: Pandarathil, Vijaymohan R
> > > > > > Cc: Blue Swirl; Alex Williamson; Bjorn Helgaas; Ortiz, Lance E;
> > > > > > kvm@vger.kernel.org; qemu-devel@nongnu.org; linux-pci@vger.kernel.org;
> > > > > > linux-kernel@vger.kernel.org
> > > > > > Subject: Re: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for
> > > > VFIO-
> > > > > > PCI devices
> > > > > >
> > > > > > On Tue, Feb 05, 2013 at 09:05:19AM +0000, Pandarathil, Vijaymohan R
> > > > wrote:
> > > > > > >
> > > > > > >
> > > > > > > > -----Original Message-----
> > > > > > > > From: Gleb Natapov [mailto:gleb@redhat.com]
> > > > > > > > Sent: Tuesday, February 05, 2013 12:05 AM
> > > > > > > > To: Blue Swirl
> > > > > > > > Cc: Pandarathil, Vijaymohan R; Alex Williamson; Bjorn Helgaas;
> > > > Ortiz,
> > > > > > Lance
> > > > > > > > E; kvm@vger.kernel.org; qemu-devel@nongnu.org; linux-
> > > > > > pci@vger.kernel.org;
> > > > > > > > linux-kernel@vger.kernel.org
> > > > > > > > Subject: Re: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER
> > > > for
> > > > > > VFIO-
> > > > > > > > PCI devices
> > > > > > > >
> > > > > > > > On Sun, Feb 03, 2013 at 04:36:11PM +0000, Blue Swirl wrote:
> > > > > > > > > On Sun, Feb 3, 2013 at 2:10 PM, Pandarathil, Vijaymohan R
> > > > > > > > > <vijaymohan.pandarathil@hp.com> wrote:
> > > > > > > > > >         - Create eventfd per vfio device assigned to a guest
> > > > and
> > > > > > > > register an
> > > > > > > > > >           event handler
> > > > > > > > > >
> > > > > > > > > >         - This fd is passed to the vfio_pci driver through the
> > > > > > SET_IRQ
> > > > > > > > ioctl
> > > > > > > > > >
> > > > > > > > > >         - When the device encounters an error, the eventfd is
> > > > > > signalled
> > > > > > > > > >           and the qemu eventfd handler gets invoked.
> > > > > > > > > >
> > > > > > > > > >         - In the handler decide what action to take. Current
> > > > action
> > > > > > > > taken
> > > > > > > > > >           is to terminate the guest.
> > > > > > > > >
> > > > > > > > > Usually this is not OK, but I guess this is not guest
> > > > triggerable.
> > > > > > > > >
> > > > > > > > Still not OK. Why not stop a guest with appropriate stop reason?
> > > > > > >
> > > > > > > The thinking was that since this is a hardware error, we would want
> > > > to
> > > > > > stop the guest at the earliest. The hw_error() routine which aborts the
> > > > > > qemu process was suggested by Alex and that seemed appropriate. Earlier
> > > > I
> > > > > > was using qemu_system_shutdown_request().  Any suggestions ?
> > > > > > >
> > > > > > I am thinking vm_stop(). Stopping SMP guest (and UP too in fact)
> > > > > > involves sending IPIs to other cpus running guest's vcpus. Both exit()
> > > > > > and vm_stop() will do it, but former is implicitly in the kernel and
> > > > > > later is explicitly in QEMU.
> > > > >
> > > > > I had used vm_stop(RUN_STATE_SHUTDOWN) earlier in my code. But while
> > > > testing, guest ended up in a hang rather than exiting. There seems to some
> > > > cleanup work which is being done as part of vm_stop. In our case, we wanted
> > > > the guest to exit immediately. So use of hw_error() seemed appropriate.
> > > > >
> > > > What makes you think it hang? It stopped, precisely what it should do if
> > > > you call vm_stop(). Now it is possible for vm user to investigate what
> > > > happened and even salvage some data from guest memory.
> > > 
> > > That was ignorance on my part on the expected behavior of vm_stop(). 
> > > So what you are suggesting is to stop the guest displaying an appropriate 
> > > error/next-steps message and have the users do any data-collection/investigation 
> > > and then manually kill the guest, if they so desire. Right ?
> > > 
> > > Sounds reasonable. As long as the guest is not touching the device, it should be okay.
> > > Alex, Any comments ?
> > 
> > What's the libvirt behavior when a guest goes to vm_stop?  My only
> > concern would be whether the user is going to be confused by a state
> > where the vm is still up, but not running.  I imagine they'll have to
> > manually stop it and restart it to continue.  Thanks,
> > 
> vm_stop() is already the behaviour on KVM internal errors, so management
> stack knows how to handle those. Of course vfio should use meaningful
> stop reason and not just reuse existing one.

Ok, sounds like a good approach to me.  Thanks,

Alex


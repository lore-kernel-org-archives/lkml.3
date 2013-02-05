Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3BEIEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:04:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3BEIEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:04:41 -0500
Date: Tue, 5 Feb 2013 10:04:36 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Blue Swirl <blauwirbel@gmail.com>
Cc: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for
 VFIO-PCI devices
Message-ID: <20130205080436.GV23213@redhat.com>
References: <F9E001219150CB45BEDC82A650F360C9014AAF07@G9W0717.americas.hpqcorp.net>
 <CAAu8pHvk_2Mf2F-YTDC-wdyD1Jic-DHUanSQfOa3g0VchTcNig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAu8pHvk_2Mf2F-YTDC-wdyD1Jic-DHUanSQfOa3g0VchTcNig@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 04:36:11PM +0000, Blue Swirl wrote:
> On Sun, Feb 3, 2013 at 2:10 PM, Pandarathil, Vijaymohan R
> <vijaymohan.pandarathil@hp.com> wrote:
> >         - Create eventfd per vfio device assigned to a guest and register an
> >           event handler
> >
> >         - This fd is passed to the vfio_pci driver through the SET_IRQ ioctl
> >
> >         - When the device encounters an error, the eventfd is signalled
> >           and the qemu eventfd handler gets invoked.
> >
> >         - In the handler decide what action to take. Current action taken
> >           is to terminate the guest.
> 
> Usually this is not OK, but I guess this is not guest triggerable.
> 
Still not OK. Why not stop a guest with appropriate stop reason?

--
			Gleb.

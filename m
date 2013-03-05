Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3CEWmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:42:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:50886 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab3CEWmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:42:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="264875217"
Date: Tue, 5 Mar 2013 14:41:50 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, Frederik Himpe <fhimpe@vub.ac.be>,
        Oliver Neukum <oneukum@suse.de>, David Haerdeman <david@hardeman.nu>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] pci: do not try to assign irq 255
Message-ID: <20130305224150.GE8339@xanatos>
References: <1361182193-31894-1-git-send-email-hare@suse.de>
 <CAE9FiQWP1F5mLUoHoTHXy-wQoGxVK66QuuHYydaq3YfysS5Etg@mail.gmail.com>
 <5124820D.2080900@suse.de>
 <CAE9FiQXHteymDNzu0GqWtVSVhu3g2hCT+K9e5tB1mR-OBX1ffA@mail.gmail.com>
 <5125C45A.5020208@suse.de>
 <CAErSpo5j3Qge5Q2S+hyMGOcmoN77V0T=1+6OJdNJfJdnvT8wgg@mail.gmail.com>
 <51305B99.6080806@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51305B99.6080806@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 08:41:13AM +0100, Hannes Reinecke wrote:
> On 02/27/2013 10:13 PM, Bjorn Helgaas wrote:
> >[+cc Andy]
> >
> >3) I don't understand why the xhci init fails in the first place.  It
> >looks like the "request interrupt 255 failed" message is from
> >xhci_try_enable_msi(), but that function tries to enable MSI-X, then
> >MSI, then falls back to legacy interrupts, where we get the error.
> >But the device supports MSI, so I don't know why we even fall back to
> >trying legacy interrupts.  Hannes, do you have any insight into that?
> >Obviously I'm missing something here.
> >
> Hehe. Due to overly clever design.
> xhci actually sets up interrupts _twice_, once per request_irq() in
> the generic code and a second time during xhci_run.
> But as the first call fails it'll never ever run the second part.
> 
> I'll be sending a patch.

Something like this?

http://marc.info/?l=linux-usb&m=132972894117916&w=2

(Apparently we had this issue around the same time last year, but we
thought the BIOS bug had been resolved.)

Sarah Sharp

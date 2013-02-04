Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3BDW2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:28:09 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:44648
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755019Ab3BDW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:28:07 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2013 17:28:07 EST
Message-ID: <1360016458.4485.11.camel@rhapsody>
Subject: Re: [PATCH v2 2/7] PCI: don't touch enable_cnt in
 pci_device_shutdown()
From: Khalid Aziz <khalid@gonehiking.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Andi Kleen <ak@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg@redhat.com>, khalid.aziz@oracle.com
Date: Mon, 04 Feb 2013 15:20:58 -0700
In-Reply-To: <20130204115557.5569.9748.stgit@zurg>
References: <20130204115246.5569.85829.stgit@zurg>
	 <20130204115557.5569.9748.stgit@zurg>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 15:55 +0400, Konstantin Khlebnikov wrote:
> Matthew Garrett and Alan Cox said (see LKML link below) that clearing bus-master
> for all PCI devices may lead to unpredictable consequences, some devices ignores
> this bit and continues DMA, some of them hang after that or crash whole system.
> Probably we should leave here only warning and disable bus-mastering for each
> driver individually in ->shutdown() callback.

Agreed that the right place for shutting down a PCI device properly and
clearing its Bus Master bit, is the driver shutdown routine, if only all
drivers supplied a shutdown routine. As it is today, there are too many
drivers that do not provide a shutdown routine, ata_piix, Marvell SATA
driver, ATI AGP driver just to name a few among a large number of them.
Yet kexec is expected to work inspite of these drivers especially since
kdump depends on it. So until all PCI drivers supply a shutdown routine,
this is just a band-aid to disable interrupt and Bus Master bit in
pci_device_shutdown(). Most drivers do seem to supply a suspend and
resume function and it was discussed many years ago if it is feasible to
use the suspend() routine for drivers to shut devices down cleanly.
Maybe it is time to revisit that discussion.

>Cc: Khalid Aziz <khalid.aziz@hp.com>

Please update this to khalid@gonehiking.org

--
Khalid



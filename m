Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3CRJM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:12:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab3CRJM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:12:56 -0400
Date: Mon, 18 Mar 2013 10:12:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.9-rc1] irq 16: nobody cared (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <CAE9FiQUqPTUqPOzANnxpdfoRYPr+OiU5pFEoLKRiOFHd9Py4XQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1303181010080.9529@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org> <1460519.ejNFI1DrGk@vostro.rjw.lan> <1363280764.26318.4.camel@thor.lan> <5657408.cYX6iimiA4@vostro.rjw.lan> <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz> <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz> <alpine.LNX.2.00.1303151609480.9529@pobox.suse.cz> <CAE9FiQUqPTUqPOzANnxpdfoRYPr+OiU5pFEoLKRiOFHd9Py4XQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013, Yinghai Lu wrote:

> > Just a datapoint -- I have put a trivial debugging patch in place, and it
> > reveals that "nobody cared" for irq 16 happens long after last
> >
> >         I915_WRITE(GMBUS4 + reg_offset, 0);
> >
> > has been performed in gmbus_wait_hw_status(). On the other hand, if I
> > comment out both GMBUS4 register offset writes in gmbus_wait_hw_status(),
> > then it of course falls back to GPIO bit-banging, but the "nobody cared"
> > for irq 16 is gone.
> >
> > So it seems like something gets severely confused by the I915_WRITE to
> > GMBUS4 + reg_offset. So far this seems to have been reported solely on
> > Lenovos as far as I can see (although a completely different types), so it
> > might be some platform-specific quirk?
> >
> > Honestly, I still don't understand how all the GMBUS stuff relates to IRQ
> > 16 at all.
> 
> that device is using
> i915 0000:00:02.0: irq 44 for MSI/MSI-X
> 
> so can you try to boot with pci=nomsi?

Yes, switching from MSI to IO-APIC-fasteoi makes the report about lost 
interrupts go away.

My understanding from the other mail is that DAniel Vetter already has an 
idea what might be going wrong with IRQ acking on GM45 chipsets; hopefully 
this datapoint regarding MSI will fit into it.

-- 
Jiri Kosina
SUSE Labs

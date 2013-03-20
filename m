Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3CTRxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:53:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40598 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3CTRxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:53:18 -0400
Date: Wed, 20 Mar 2013 17:52:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Michal Marek <mmarek@suse.cz>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp: Add pciehp_surprise module option
Message-ID: <20130320175234.GA8948@srcf.ucam.org>
References: <s5h38vqjhk6.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h38vqjhk6.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:02:01PM +0100, Takashi Iwai wrote:
> We encountered a problem that on some HP machines the Realtek PCI-e
> card reader device appears only when you inserted a card before the
> cold boot.  While debugging, it turned out that the device is actually
> handled via PCI-e hotplug in some level.  The device sends a presence
> change notification, and pciehp receives it, but it's ignored because
> of lack of the hotplug surprise (PCI_EXP_SLTCAP_HPS) capability bit.
> Once when this check passes, everything starts working -- the device
> appears upon plugging the card properly.

Well that just sounds like a bug. What's the downside to just ignoring 
that capability bit?

-- 
Matthew Garrett | mjg59@srcf.ucam.org

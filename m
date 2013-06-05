Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3FEUJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:09:06 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42072 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757286Ab3FEUJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:09:04 -0400
Date: Wed, 5 Jun 2013 22:08:07 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3 -tip x86/apic 2/2] x86/MSI: Conserve interrupt
 resources when using multiple-MSIs
Message-ID: <20130605200807.GA5198@breakpoint.cc>
References: <cover.1368431413.git.agordeev@redhat.com>
 <924d05fe41fb93fdc2013680fb220d4b171de303.1368431413.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924d05fe41fb93fdc2013680fb220d4b171de303.1368431413.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:06:17AM +0200, Alexander Gordeev wrote:
> Current multiple-MSI implementation does not take into account
> actual number of requested MSIs and always rounds that number
> to a closest power-of-two value. Yet, a number of MSIs a PCI
> device could send (and therefore a number of messages a device
> driver could request) may be a lesser power-of-two. As result,
> resources allocated for extra MSIs just wasted.
> 
> This update takes advantage of 'msi_desc::nvec' field introduced
> with generic MSI code to track number of requested and used MSIs.
> As result, resources associated with interrupts are conserved.
> Of those resources most noticeable are x86 interrupt vectors.
> 
> The initial version of this fix also consumed on IRTEs, but Jan
> noticed that a malfunctioning PCI device might send a message
> number it did not claim and thus refer an IRTE it does not own.
> To avoid this security hole the old-way approach preserved and
> as many IRTEs are reserved as the device could possibly send.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

This does not look all that bad.

Sebastian

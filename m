Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3KVSo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:44:57 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:35396 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVSoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:44:55 -0500
Date: Fri, 22 Nov 2013 13:44:47 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*()
 family helpers
Message-ID: <20131122184447.GB8981@mtj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
 <20131120171526.GL28946@htj.dyndns.org>
 <20131122184429.GG8401@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122184429.GG8401@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 07:44:30PM +0100, Alexander Gordeev wrote:
> On Wed, Nov 20, 2013 at 12:15:26PM -0500, Tejun Heo wrote:
> > The use of @nvec and @maxvec is a bit inconsistent.  Maybe it'd be
> > better to make them uniform?
> 
> With @maxvec I tried to stress an implication there could be values
> less than @maxvec. While @nvec is more like an exact number.
> Perfectly makes sense to me, but this is personal :)

Oh yeah, I agree but saw a place where @nvec is used for max.  Maybe I
was confused.  Looking again...

+int pcim_enable_msi_range(struct pci_dev *dev, struct msix_entry *entries,
+                         unsigned int nvec, unsigned int minvec)
+
+This variation on pci_enable_msi_block() call allows a device driver to
+request any number of MSIs within specified range minvec to nvec. Whenever
+possible device drivers are encouraged to use this function rather than
+explicit request loop calling pci_enable_msi_block().

e.g. shouldn't that @nvec be @maxvec?

Thanks.

-- 
tejun

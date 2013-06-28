Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3F1S3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:29:49 -0400
Received: from 8bytes.org ([85.214.48.195]:47157 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab3F1S3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:29:47 -0400
Date: Fri, 28 Jun 2013 20:29:46 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
Message-ID: <20130628182946.GU11309@8bytes.org>
References: <lhtAZ-q1-5@gated-at.bofh.it>
 <lhtB1-q1-53@gated-at.bofh.it>
 <20130628181136.52d00e9c@dualc.maya.org>
 <1372441744.30572.765.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372441744.30572.765.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 28 20:29:46 2013
X-DSPAM-Confidence: 0.9974
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51cdd61a20861916217421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Fri, Jun 28, 2013 at 11:49:04AM -0600, Alex Williamson wrote:
> That's interesting, I PXE boot my system from one NIC then use a
> different NIC for the iSCSI root.  The PXE boot NIC now screams like
> this, _until_ I attach it to vfio, then it quiets down.

Can you please send an example line of the reported fault? The addresses
it faults on would be interesting.

> > Any idea?
> 
> Not really without some digging.  I wonder if it's a new event each time
> or if something is just not clearing a previous event.  ISTR that a boot
> used to often, but not always, generate a couple faults between the
> IOMMU being enabled and the NIC driver being loaded.  All the faults I
> see are to the same address, so my guess is that it's getting replayed.

Well, I think it is a problem uncovered by the patch that re-enables the
event-log interrupt after it happened once. We need to find a strategy
to cope with those problems.

To my mind as a quick-fix comes rate-limiting for the printks. Or we use
the suppress-pf bit in the DTE to suppress all page-faults after the
first one.


	Joerg



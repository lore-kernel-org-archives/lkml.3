Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937436Ab3DIKIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:08:07 -0400
Received: from 8bytes.org ([85.214.48.195]:35333 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933562Ab3DIKIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:08:05 -0400
Date: Tue, 9 Apr 2013 12:08:01 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v6] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130409100801.GF6858@8bytes.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1365190294-9061-1-git-send-email-nhorman@tuxdriver.com>
 <CAErSpo6z8oqiaUBCieUMsS_c5xvVFUDbHqVO_eBBde3uv2=zcg@mail.gmail.com>
 <5162E266.6080002@redhat.com>
 <CAErSpo5DNe-x6Fi3i6K=9xnd47d-T-q4_bH0tiud_8Ak2eL=TQ@mail.gmail.com>
 <20130408174257.GA13960@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408174257.GA13960@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 12:08:03 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5163e88323671373659066
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 01:42:57PM -0400, Neil Horman wrote:
> On Mon, Apr 08, 2013 at 11:17:23AM -0600, Bjorn Helgaas wrote:

> > I don't care whether the "if (irq_remap_broken)" test is in
> > irq_remapping.c or intel_irq_remapping.c.  The quirk itself, where we
> > actually look at config space, is clearly Intel-specific, but there
> > could easily be similar AMD quirks that could also set
> > irq_remap_broken.  In that case, it would make sense to have the test
> > in the common code.
> > 
> I've moved it to intel specific code for the time being, since it currently is
> intel specific, its an easy move to put it in a common location if other vendors
> have a need for it.
> 
> I'm currently waiting on aproval to make the bz public, so that its inclusion in
> the changelog is more than just an irritation when following the link results in
> a 403 error.  As soon as thats square, I'll post this again, CC-ing Jeorg and
> Konrad.

Thanks Neil. As long as this quirk is intel specific it should be in
the intel-code.


	Joerg



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162634Ab3DET36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:29:58 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47473 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162581Ab3DET34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:29:56 -0400
Date: Fri, 5 Apr 2013 15:29:49 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130405192949.GA1094@hmsreliant.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1365189954-8896-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365189954-8896-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 03:25:54PM -0400, Neil Horman wrote:
> A few years back intel published a spec update:
> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
> 
> For the 5520 and 5500 chipsets which contained an errata (specificially errata
> 53), which noted that these chipsets can't properly do interrupt remapping, and
> as a result the recommend that interrupt remapping be disabled in bios.  While
> many vendors have a bios update to do exactly that, not all do, and of course
> not all users update their bios to a level that corrects the problem.  As a
> result, occasionally interrupts can arrive at a cpu even after affinity for that
> interrupt has be moved, leading to lost or spurrious interrupts (usually
> characterized by the message:
> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
> 
> There have been several incidents recently of people seeing this error, and
> investigation has shown that they have system for which their BIOS level is such
> that this feature was not properly turned off.  As such, it would be good to
> give them a reminder that their systems are vulnurable to this problem.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: Don Zickus <dzickus@redhat.com>
> CC: Don Dutile <ddutile@redhat.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Asit Mallick <asit.k.mallick@intel.com>
> CC: David Woodhouse <dwmw2@infradead.org>
> CC: linux-pci@vger.kernel.org
> ---
> 
> Change notes:
> 
> v2)
> 
> * Moved the quirk to the x86 arch, since consensus seems to be that the 55XX
> chipset series is x86 only.  I decided however to keep the quirk as a regular
> quirk, not an early_quirk.  Early quirks have no way currently to determine if
> BIOS has properly disabled the feature in the iommu, at least not without
> significant hacking, and since its quite possible this will be a short lived
> quirk, should Don Z's workaround code prove successful (and it looks like it may
> well), I don't think that necessecary.
> 
> * Removed the WARNING banner from the quirk, and added the HW_ERR token to the
> string, I opted to leave the newlines in place however, as I really couldnt
> find a way to keep the text on a single line is still legible from a code
> perspective.  I think theres enough language in there that using cscope on just
> about any substring however will turn it up, and again, this may be a short
> lived quirk.
> 
> v3)
> 
> * Removed defines from pci_ids.h, and used direct id values as per request from
> Bjorn.
> 
> v4)
> 
> * Converted pr_warn to WARN_TAINT(TAINT_FIRMWARE_WORKAROUND) as per David
> Woodhouse
> 
> v5)
> 
> * Moved check to an early quirk, and flagged the broken chip, so we could
> reasonably disable irq remapping during bootup.


Self NAK, sorry, I've got extra water in the quirks file left over from my move.


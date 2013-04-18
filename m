Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967829Ab3DRRAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:00:51 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45161 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967397Ab3DRRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:00:48 -0400
Date: Thu, 18 Apr 2013 13:00:30 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: Re: [PATCH v10] irq: add quirk for broken interrupt remapping on
 55XX chipsets
Message-ID: <20130418170030.GB3788@neilslaptop.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1366144712-23460-1-git-send-email-nhorman@tuxdriver.com>
 <20130418150222.GB2558@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130418150222.GB2558@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 05:02:39PM +0200, Joerg Roedel wrote:
> On Tue, Apr 16, 2013 at 04:38:32PM -0400, Neil Horman wrote:
> > A few years back intel published a spec update:
> > http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
> > 
> > For the 5520 and 5500 chipsets which contained an errata (specificially errata
> > 53), which noted that these chipsets can't properly do interrupt remapping, and
> > as a result the recommend that interrupt remapping be disabled in bios.  While
> > many vendors have a bios update to do exactly that, not all do, and of course
> > not all users update their bios to a level that corrects the problem.  As a
> > result, occasionally interrupts can arrive at a cpu even after affinity for that
> > interrupt has be moved, leading to lost or spurrious interrupts (usually
> > characterized by the message:
> > kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
> > 
> > There have been several incidents recently of people seeing this error, and
> > investigation has shown that they have system for which their BIOS level is such
> > that this feature was not properly turned off.  As such, it would be good to
> > give them a reminder that their systems are vulnurable to this problem.  For
> > details of those that reported the problem, please see:
> > https://bugzilla.redhat.com/show_bug.cgi?id=887006
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Prarit Bhargava <prarit@redhat.com>
> > CC: Don Zickus <dzickus@redhat.com>
> > CC: Don Dutile <ddutile@redhat.com>
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Asit Mallick <asit.k.mallick@intel.com>
> > CC: David Woodhouse <dwmw2@infradead.org>
> > CC: linux-pci@vger.kernel.org
> > CC: Joerg Roedel <joro@8bytes.org>
> > CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > CC: Arkadiusz Miśkiewicz <arekm@maven.pl>
> 
> Applied with some small changes to my x86/vt-d branch, thanks Neil.
> 
> 
> 
Thanks!
Neil


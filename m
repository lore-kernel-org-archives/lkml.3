Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3CKLZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:25:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38474 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3CKLZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:25:11 -0400
Date: Mon, 11 Mar 2013 07:25:00 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Myron Stowe <myron.stowe@gmail.com>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130311112500.GA12682@hmsreliant.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com>
 <20130309204940.GA31808@neilslaptop.think-freely.org>
 <CAL-B5D15YY6L01q6BCNnP5VCJN7=LeHJSYLjNGXZPRx7VhsZCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL-B5D15YY6L01q6BCNnP5VCJN7=LeHJSYLjNGXZPRx7VhsZCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 03:20:57PM -0700, Myron Stowe wrote:
> On Sat, Mar 9, 2013 at 1:49 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Mon, Mar 04, 2013 at 02:04:19PM -0500, Neil Horman wrote:
> >> A few years back intel published a spec update:
> >> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
> >>
> >> For the 5520 and 5500 chipsets which contained an errata (specificially errata
> >> 53), which noted that these chipsets can't properly do interrupt remapping, and
> >> as a result the recommend that interrupt remapping be disabled in bios.  While
> >> many vendors have a bios update to do exactly that, not all do, and of course
> >> not all users update their bios to a level that corrects the problem.  As a
> >> result, occasionally interrupts can arrive at a cpu even after affinity for that
> >> interrupt has be moved, leading to lost or spurrious interrupts (usually
> >> characterized by the message:
> >> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
> >>
> >> There have been several incidents recently of people seeing this error, and
> >> investigation has shown that they have system for which their BIOS level is such
> >> that this feature was not properly turned off.  As such, it would be good to
> >> give them a reminder that their systems are vulnurable to this problem.
> >>
> >> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> >> CC: Prarit Bhargava <prarit@redhat.com>
> >> CC: Don Zickus <dzickus@redhat.com>
> >> CC: Don Dutile <ddutile@redhat.com>
> >> CC: Bjorn Helgaas <bhelgaas@google.com>
> >> CC: Asit Mallick <asit.k.mallick@intel.com>
> >> CC: linux-pci@vger.kernel.org
> >>
> > Ping, anyone want to Ack/Nack this?
> 
> Don's comment earlier seems to imply that this is a short term fix and
> that a more long term fix may be coming soon.  If that is the case
> wouldn't we want to wait for the long term fix and just pull that in?
> 
> Myron
> 
As Don and Prarit have mentioned, an alternate change is being worked on and
tested that may work around this issue, but we're not yet sure that it will, and
we're not sure of the time frame for this fix.  Normally I would agree, that it
would be easier just to wait for the long term fix, but as Prarit noted, since
this hardware is in fact broken, I would rather do a both approach.  Its fine if
this gets reverted tomorrow with a longer term fix as far as I'm concerned, its
just caused enough problems already that I'd like to see it in place until the
better solution arrives.
Neil
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaF0LRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:17:55 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27815 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752895AbaF0LRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:17:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+KnnEX7ECtf5tDjp9I5FYtwwdWD77oUaI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 582D959B5E7
Date: Fri, 27 Jun 2014 07:17:46 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Feng Kan <fkan@apm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <marc.zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH V2 2/2] irqchip: gic: preserve gic V2 bypass bits in
 cpu ctrl register
Message-ID: <20140627111746.GV10202@titan.lakedaemon.net>
References: <1403734041-5112-1-git-send-email-fkan@apm.com>
 <1403734041-5112-3-git-send-email-fkan@apm.com>
 <alpine.DEB.2.10.1406260302510.5170@nanos>
 <CAL85gmAPXDTO2x4esYNq1ZHUAwuNTtMCNtc+ODwnrNPEaDH_1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL85gmAPXDTO2x4esYNq1ZHUAwuNTtMCNtc+ODwnrNPEaDH_1w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 09:48:25AM -0700, Feng Kan wrote:
> On Wed, Jun 25, 2014 at 6:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 25 Jun 2014, Feng Kan wrote:
> >
> >> This change is made to preserve the GIC v2 bypass bits in the
> >> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
> >> This code will preserve all bits configured by the bootloader regarding
> >> v2 bypass group bits. In the X-Gene platform, the bypass functionality
> >> is not used and bypass bits should not be changed by the kernel gic
> >> code as it could lead to incorrect behavior.
> >>
> >> Signed-off-by: Vinayak Kale <vkale@apm.com>
> >> Signed-off-by: Feng Kan <fkan@apm.com>
> >
> > Who wrote the patch? According to the SOB chain it's Vinayak, but your
> > patch is missing the:
> 
> I wrote the patch which was based on Vinayak's original change. I can
> change it to
> Reviewed-by. I was trying to give him credit.
> 

Then please leave the S-o-b's alone and append a note describing the
changes you made to his original patch.

eg:

----->8-------------
From: Vinayak Kale <vkale@apm.com>

This change is made to preserve the GIC v2 bypass bits in the
GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
This code will preserve all bits configured by the bootloader regarding
v2 bypass group bits. In the X-Gene platform, the bypass functionality
is not used and bypass bits should not be changed by the kernel gic
code as it could lead to incorrect behavior.

[Feng Kan: Rebased on magic number removal patch, added feature X, fixed
bug Y.]

Signed-off-by: Vinayak Kale <vkale@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
----->8-------------

'git am' will use the info from the last 'From:' as the author of the
commit.

It goes without saying (even though I'm mentioning it ;-) ) the S-o-b
means a very specific thing.  It is *not* there to enhance credit.  It
is there to indicate that the person referenced (yourself and Vinayak)
have read, understood, and consent to the Developer's Certificate of
Origin [1].  Nothing else.

The commit message tags have one purpose:  To accurately render
information about a commit.  Who wrote it, who applied it, who reviewed
it, who let it go by a different tree than the default for a subsystem,
etc.

Attempts to (mis)use them as a corporate evaluation metric only leads to
developers trying to game the system.  More importantly, it wastes
maintainers time because now we have to question whether the appended
tags are indeed factual. :(

thx,

Jason.

[1] Documentation/SubmittingPatches, Section 12.

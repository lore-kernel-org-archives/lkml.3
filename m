Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3CUVdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:33:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3CUVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:33:53 -0400
Date: Thu, 21 Mar 2013 14:33:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dgilbert@interlog.com
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: rtc-at91rm9200: use a variable for storing IMR
Message-Id: <20130321143351.3a9c20248e283649334d4251@linux-foundation.org>
In-Reply-To: <514A5F2B.8030707@interlog.com>
References: <1363369032-12639-1-git-send-email-nicolas.ferre@atmel.com>
	<20130320145006.f1431c1528325ff93a298790@linux-foundation.org>
	<514A5F2B.8030707@interlog.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013 21:15:23 -0400 Douglas Gilbert <dgilbert@interlog.com> wrote:

> On 13-03-20 05:50 PM, Andrew Morton wrote:
> > On Fri, 15 Mar 2013 18:37:12 +0100 Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> >
> >> On some revisions of AT91 SoCs, the RTC IMR register is not working.
> >> Instead of elaborating a workaround for that specific SoC or IP version,
> >> we simply use a software variable to store the Interrupt Mask Register and
> >> modify it for each enabling/disabling of an interrupt. The overhead of this
> >> is negligible anyway.
> >
> > This description doesn't really allow me or others to work out whether
> > the fix should be included in 3.9 or backported into earlier kernels.
> >
> > So please, when fixing a bug do include a full description of the
> > user-visible effects of that bug.  And your opinion regarding the
> > -mainline and -stable decision is always useful.
> 
> The interrupt mask register (IMR) for the RTC is broken
> on the AT91SAM9x5 sub-family of SoCs (good overview of the
> members here: http://www.eewiki.net/display/linuxonarm/AT91SAM9x5 ).
> The "user visible effect" is the RTC doesn't work.
> 
> That sub-family is less than two years old and only has devicetree
> (DT) support and came online circa lk 3.7 . The dust is yet to
> settle on the DT stuff at least for AT91 SoCs (translation:
> lots of stuff is still broken, so much that it is hard to know
> where to start).
> 
> The fix in the patch is pretty simple: just shadow the silicon
> IMR register with a variable in the driver. Some older SoCs (pre-DT)
> use the the rtc-at91rm9200 driver (e.g. obviously the AT91RM9200)
> and they should not be impacted by the change. There shouldn't
> be a large volume of interrupts associated with a RTC.

Thanks.

> Compared to a relatively stable kernel subsystem like SCSI, what
> is happening in the ARM architecture with DT is huge and ongoing.
> So I think you either need new rules or suspend some of the stricter
> rules applied to more stable subsystems. Just my two cents worth.

I don't know what this means.

Shrug.  I tagged the patch for -stable backporting on the basis that
"the RTC doesn't work" is undesirable ;)

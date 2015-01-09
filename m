Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbbAIWeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:34:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbbAIWeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:34:02 -0500
Date: Fri, 9 Jan 2015 14:34:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefan Agner <stefan@agner.ch>
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] serial: fsl_lpuart: fix various DMA related issues
Message-ID: <20150109223401.GA15118@kroah.com>
References: <1417134205-4400-1-git-send-email-stefan@agner.ch>
 <677f2c62b6b6c1fe8e16cd38d5f20d47@agner.ch>
 <20141212143244.GA2219@kroah.com>
 <f6255321feb06d32f257b7b41d5d58a3@agner.ch>
 <20150109221432.GA4056@kroah.com>
 <742637f13bc97ecaadd1d264cd0ad4cc@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <742637f13bc97ecaadd1d264cd0ad4cc@agner.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 11:19:50PM +0100, Stefan Agner wrote:
> On 2015-01-09 23:14, Greg KH wrote:
> > On Fri, Dec 12, 2014 at 05:19:02PM +0100, Stefan Agner wrote:
> >> On 2014-12-12 15:32, Greg KH wrote:
> >> > On Fri, Dec 12, 2014 at 02:44:06PM +0100, Stefan Agner wrote:
> >> >> Any thoughts on this patchset? Would have hopped that it makes it into
> >> >> 3.19 as those are mostly fixes.
> >> >
> >> > "mostly"?
> >> >
> >>
> >> Well, all of them fix a bug, but PATCH 2/4 does this by also moving DMA
> >> allocation to probe. I would really have to split up that patch and make
> >> two incremental steps (split-up of RX/TX DMA allocation to make each
> >> single action revert-able and move to probe). But this would lead to
> >> more changed lines in total. The patchset as is already somewhat tested
> >> since we use it in our 3.18 BSP, whereas a new set would not be tested.
> >>
> >> One could also argument, it only affects fsl_lpuart (UART in rather not
> >> very widespread SoC's Freescale Vybrid and LS1021a).
> >>
> >>
> >> > I'll get to these after 3.19-rc1 is out, but it really looks like these
> >> > will be for 3.20-rc1, unless you break them up into "bugfix only" type
> >> > patches.
> >>
> >>
> >> PATCH 1/4 fixes a bug which happens on a normal console rather often on
> >> my setup. So if you decide that patchset is for 3.20-rc1, that one would
> >> be nice to have in 3.19 as well...
> > 
> > Please redo this patchset then, makeing it obvious that some are fixes,
> > and need to go for 3.19 and others are ok for 3.20.  As it is, the
> > changelog entries do not look like anything here is for 3.19, sorry.
> > 
> 
> Ok, will create a patchset with 1 and 3 for 3.19 (since this two really
> lead to reproducible kernel traces), and the rest for 3.20. Do you
> prefer to have the patches in a single patchset (with 3 moved to 2) or
> should I create two patchsets?

What would you want if you were in my shoes and had to maintain two
different branches?

(hint, two different patchsets...)

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaEOPHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:07:09 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:35623 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaEOPGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:06:55 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 3/3] of: Handle memory@0 node on PPC32 only
To: Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>
In-Reply-To: <20140424092642.GQ5904@bivouac.eciton.net>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
	<1397756521-29387-4-git-send-email-leif.lindholm@linaro.org>
	<CAMuHMdXBNWum7UJ95uT2hwTd1b5C8ebF2LQ4T-A+RS80p7MH=A@mail.gmail.com>
	<20140418125924.GF5904@bivouac.eciton.net>
	<20140422133515.E7A0BC40754@trevor.secretlab.ca>
	<20140423104528.GD30036@e106331-lin.cambridge.arm.com>
	<20140423131058.D94B6C408D2@trevor.secretlab.ca>
	<20140424092642.GQ5904@bivouac.eciton.net>
Date: Thu, 15 May 2014 15:59:00 +0100
Message-Id: <20140515145900.703EEC4095B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014 10:26:42 +0100, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> On Wed, Apr 23, 2014 at 02:10:58PM +0100, Grant Likely wrote:
> > > Does anyone have a LongTrail DT to hand, and if so does the root have a
> > > compatible string? From grepping through the kernel I could only find a
> > > model string ("IBM,LongTrail").
> > 
> > Actually, on LongTrail this can be removed from the common code
> > entirely. It has real open firmware and PowerPC already has the
> > infrastructure for fixing up the device tree.
> > 
> > Here's a draft patch that I've compile tested, but nothing else.
> 
> I would certainly be happy with that.
> 
> Consider my 3/3 withdrawn.
> 
> And if the kernel proper will stop honoring nodes with no type,
> there is no need for the stub to treat those specially either.

So, after thinking about it some more, I've changed my minde about the
whole thing again. The impact is quite contained because there weren't a
lot of systems that had ram based at 0. I'm going to commit this patch,
but I'll include a note in the commit text that if it causes trouble for
anyone that they should yell and I'll revert it. I don't think it will
though.

g.


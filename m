Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaDVNIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:08:42 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54944 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDVNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:08:39 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/3] of: dts: enable memory@0 quirk for PPC32 only
To: Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mark Rutland <mark.rutland@arm.com>
In-Reply-To: <CAL_JsqKdFyhHfkcC1E9QuKjQTrXwoELYG+CFTpgf2-jqDvxGmA@mail.gmail.com>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
	<CAL_JsqL8B2ZY7ACXKX3J8VN5ukjKWuycgfDZpp4kYzBxg6BLmQ@mail.gmail.com>
	<20140418124821.GE5904@bivouac.eciton.net>
	<CAL_JsqKdFyhHfkcC1E9QuKjQTrXwoELYG+CFTpgf2-jqDvxGmA@mail.gmail.com>
Date: Tue, 22 Apr 2014 14:08:29 +0100
Message-Id: <20140422130829.CA29DC4042C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2014 10:37:58 -0500, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Apr 18, 2014 at 7:48 AM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> > On Thu, Apr 17, 2014 at 07:43:13PM -0500, Rob Herring wrote:
> >> On Thu, Apr 17, 2014 at 12:41 PM, Leif Lindholm
> >> <leif.lindholm@linaro.org> wrote:
> >> > drivers/of/fdt.c contains a workaround for a missing memory type
> >> > entry on longtrail firmware. Make that quirk PPC32 only, and while
> >> > at it - fix up the .dts files in the tree currently working only
> >> > because of that quirk.
> >>
> >> But why do you need this?
> >
> > Apart from the current code permitting recreating a 15+ year old
> > firmware bug into completely new platform ports?
> 
> I would prefer to see a "WARN_ON(!IS_ENABLED(CONFIG_PPC32));" added here.

I completely agree.

> Really, I would like to see quirks like this fixed up out of line from
> the normal flow somewhat like how PCI quirks are handled. So in this
> example, we would just add the missing property to the dtb for the
> broken platform before doing the memory scan. That does then require
> libfdt which is something I'm working on.

In fact, for Leif's purposes, I would rather have a flag when booting via
UEFI, and make the kernel skip the memory node parsing if the UEFI
memory map is available. Then the stub doesn't need to do any munging of
the DTB at all.

g.


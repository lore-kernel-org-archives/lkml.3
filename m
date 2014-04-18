Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaDRMpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:45:06 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:39827 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDRMo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:44:59 -0400
Date: Fri, 18 Apr 2014 13:48:22 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 0/3] of: dts: enable memory@0 quirk for PPC32 only
Message-ID: <20140418124821.GE5904@bivouac.eciton.net>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
 <CAL_JsqL8B2ZY7ACXKX3J8VN5ukjKWuycgfDZpp4kYzBxg6BLmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqL8B2ZY7ACXKX3J8VN5ukjKWuycgfDZpp4kYzBxg6BLmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 07:43:13PM -0500, Rob Herring wrote:
> On Thu, Apr 17, 2014 at 12:41 PM, Leif Lindholm
> <leif.lindholm@linaro.org> wrote:
> > drivers/of/fdt.c contains a workaround for a missing memory type
> > entry on longtrail firmware. Make that quirk PPC32 only, and while
> > at it - fix up the .dts files in the tree currently working only
> > because of that quirk.
> 
> But why do you need this?

Apart from the current code permitting recreating a 15+ year old
firmware bug into completely new platform ports?

Because the UEFI stub for arm/arm64 needs to delete all of the "memory"
nodes from the DT. And it would be nice to at least not have to compile
the "and also delete anything called memory@0" into the arm64 image. Or
any image not including support for affected platforms.

> >  arch/arm/boot/dts/ste-ccu8540.dts     |    1 +
> >  arch/mips/lantiq/dts/easy50712.dts    |    1 +
> >  arch/mips/ralink/dts/mt7620a_eval.dts |    1 +
> >  arch/mips/ralink/dts/rt2880_eval.dts  |    1 +
> >  arch/mips/ralink/dts/rt3052_eval.dts  |    1 +
> >  arch/mips/ralink/dts/rt3883_eval.dts  |    1 +
> 
> I'm not worried about these MIPS dts files because they are all
> built-in, but you are breaking compatibility with old dtbs for this
> ARM board.

Yeah, sorry. Sending out a v2 of part 3 shortly.

/
    Leif

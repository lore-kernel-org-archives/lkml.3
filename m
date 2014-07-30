Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaG3Chb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:37:31 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:44023 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaG3Ch3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 22:37:29 -0400
Date: Wed, 30 Jul 2014 11:37:25 +0900
From: Simon Horman <horms@verge.net.au>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>, DEVICE TREE <devicetree@vger.kernel.org>,
        Support Opensource <Support.Opensource@diasemi.com>,
        LINUX SH <linux-sh@vger.kernel.org>,
        LINUX KERNEL <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        LINUX ARM KERNEL <linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RESEND RFC V2] devicetree: Dialog Semiconductor consolidate
 existing vendor prefixes to standardise on 'dlg'
Message-ID: <20140730023725.GA23224@verge.net.au>
References: <201407241554.s6OFsqbW031651@swsrvapps-01.diasemi.com>
 <20140725070002.GH7063@lee--X1>
 <6ED8E3B22081A4459DAC7699F3695FB7D0B28E95@SW-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB7D0B28E95@SW-EX-MBX02.diasemi.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 09:53:56AM +0000, Opensource [Steve Twiss] wrote:
> On 25 July 2014 08:00, Lee Jones wrote:
> 
> >On Thu, 24 Jul 2014, Opensource [Steve Twiss] wrote:
> >> From: Steve Twiss <stwiss.opensource@diasemi.com>
> >>
> >> This patch series updates the device tree vendor prefix for
> >> Dialog Semiconductor.
> >>
> >> Various methods are currently used throughout the kernel: 'diasemi',
> >> 'dialog' and 'dlg'. Others have also been suggested.
> >>
> >> This patch set aims to consolidate the usage of the vendor prefix to
> >> use a common standard. The prefix 'dlg' is used.
> >>
> >>
> >> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
> >
> >Didn't I Ack the MFD parts already?
> >
> 
> Yes -- certainly.
>  (I should have put them in the main body of the e-mail shouldn't I ..?)
> 
> I just need the SHMobile responses now.
> I will try to make contact with those guys this week.

Hi Steve,

I apologise for not noticing this earlier:
I am entirely unsure how I missed it.

In principle I am fine with this change so long as it does not
introduce any backwards-compatibility problems. In particular removing
compatibility strings that may already be in use by DTB blobs in the wild.

For SH Mobile it seems that Lager and Koelsch were using "diasemi,da9210"
which is unsupported by the driver at this time. So it seems there is no
backwards-compatibility problem there. I'm less sure about other aspects of
the patch. And I'm also less concerned about them.

I do have a slight preference for SH Mobile changes to go through my
renesas tree rather than elsewhere (as part of a more global change)
principally to try to avoid the possibility of conflicts. The SH Mobile dts
files in question are often updated. And for example I notice some fuzz
when applying this patch on top of the next-20140729 tag of linux-next.

If you were to break out the SH Mobile portion of this patch I would be
happy to take it once the driver portion is accepted.  That said, I do see
that everyone else has acked the change so clearly this is not an issue
from their point of view. So I will not complain if you decide not to break
the patch up (though please note my warning about possible conflicts).

In the case where you do not want to split up the patch:
Acked-by: Simon Horman <horms+renesas@verge.net.au>

> I have the following Acks so far.
> 
> >From: Rob Herring on 21 July 2014 16:43
> >I'm okay with this, but it also needs acks from i.MX and SHMobile
> >folks as it could break out of tree users.
> >  Acked-by: Rob Herring <robh@kernel.org>
> 
> >From: Shawn Guo on 22 July 2014 02:38
> >arch/arm/boot/dts/imx53-smd.dts                    |  2 +-
> >arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |  2 +-
> >  Acked-by: Shawn Guo <shawn.guo@freescale.com>
> 
> >From: Lee Jones on 22 July 2014 08:09
> >For the MFD changes:
> >  Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> and
> 
> >From: Philipp Zabel on 24 July 2014 20:44
> >  Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

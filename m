Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaIXS7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:59:41 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:45742 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaIXS7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:59:39 -0400
Date: Wed, 24 Sep 2014 20:59:34 +0200
From: Frans Klaver <fransklaver@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: olof@lixom.net, anton.vorontsov@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] sbs-battery: add forced instantiation from
 device tree
Message-ID: <20140924185933.GA2221@gmail.com>
References: <1411564278-17207-1-git-send-email-frans.klaver@xsens.com>
 <1411564278-17207-2-git-send-email-frans.klaver@xsens.com>
 <20140924131655.GG5729@leverpostej>
 <20140924142222.GC22872@ci00147.xsens-tech.local>
 <20140924143848.GH5729@leverpostej>
 <20140924151448.GD22872@ci00147.xsens-tech.local>
 <20140924153431.GJ5729@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140924153431.GJ5729@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 04:34:32PM +0100, Mark Rutland wrote:
> On Wed, Sep 24, 2014 at 04:14:48PM +0100, Frans Klaver wrote:
> > On Wed, Sep 24, 2014 at 03:38:49PM +0100, Mark Rutland wrote:
> > > On Wed, Sep 24, 2014 at 03:22:22PM +0100, Frans Klaver wrote:
> > > You mention that there's a GPIO that can be used to detect the battery
> > > presence. Why can't the driver always probe and then on check for the
> > > presence of the battery dynamically using that GPIO? That should cover
> > > both cases.
> > 
> > I would say that this was the case before [1] was done. The GPIO is
> > optional and if not configured, the presence or absence of the battery
> > is detected by checking a status register much like probe() currently
> > does. It seems all cases were covered before that patch. If you worry
> > about speed, you should use the GPIO. I wonder if we might be able to
> > revert [1] without doing much harm.
> 
> But reverting that would re-introduce the lag on some systems, no? Given
> the wording of the original commit I would guess that the GPIO wasn't
> available. Perhaps Olof or Anton can enlighten us?

It probably would yes. The battery_detect gpio was last touched in 2011, the
probe check was added somewhere in 2012.

We could keep it as a compile option.

> In the cases where a GPIO is available, I think we should be able to be
> less pessimistic. Is a GPIO available in your case?

We don't have the battery_detect pin available. Incidentally, a bit of
lag reading out the battery is not a problem for us.

> Mark.
> 
> > 
> > Thanks,
> > Frans
> > 
> > [1] a22b41a31e53 "sbs-battery: Probe should try talking to the device"
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

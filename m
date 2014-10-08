Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaJHSNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:13:35 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61324 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaJHSNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:13:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Branden <sbranden@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, devicetree@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        Jonathan Richardson <jonathar@broadcom.com>,
        JD Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Date: Wed, 08 Oct 2014 20:12:38 +0200
Message-ID: <34012512.W8VifyXY4H@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <543565DC.8010704@broadcom.com>
References: <1412746025-11998-2-git-send-email-sbranden@broadcom.com> <10762659.VISiZ3vSSN@wuerfel> <543565DC.8010704@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:y2CldfNsOXdXjWl5VRYGYgB2oO0NbFHu0yv5v7UOr3E
 nv0rJLjShQm2/oSGDW0Dwo6oT6UblWjDqbClgIIyHTWJ9a+DZX
 4xA6sq5T83iUHn5jAscP7CyLJs+mBx94XaHYIXePqi5k/ekV1H
 o4RJdw/m3nauOTZipp/PnijCETYAwni403fYGOkL7IR2+p92ll
 4CauEqiSbJ51Jwzr7DKdGeqWxpnal3b24zEq6q48a582Q88ZCE
 +hdtzzpA/PSNsy6dUj6Zybxtt4q2jqQGRBal+axrxU+ocBm0is
 NFwsiwjotajJV2j9266W/Hc+9IiRLv3Rd78DbnABdlwFaiHYll
 KmN+gPKYsCzPctV4eNMk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2014 09:27:08 Scott Branden wrote:
> On 14-10-08 06:28 AM, Arnd Bergmann wrote:
> > On Wednesday 08 October 2014 05:27:24 Scott Branden wrote:
> >>>
> >>> I don't think you need per-board config options. The main option
> >>> above should be enough.
> >> This is not a per-board config option.  This is actually a per-SoC
> >> uArchtecture selection.  More major uArchectures will be added to the
> >> IPROC.  Will Change comment to "Support Broadcom Cygnus SoC"
> >
> > Ok, sounds fine, but remove ARCH_BCM_IPROC then. There should be
> > no need for a three-level deep hierarchy (BCM -> IPROC -> CYGNUS)
> >
> I do not need a 3-deep hierarchy, I need a 2-deep hierarchy for IPROC 
> and CYGNUS (and future SoCs that have IPROC Architecture in common).  I 
> can move IPROC out of the mach-bcm directory if you like a create a new 
> directory?  But it looks like the purpose of mach-bcm is to consolidate 
> all Broadcom chipsets in it?

Yes, better leave it all in mach-bcm. You really shouldn't need much
code at all that is soc specific, so adding new directories is not
encouraged. We have some platforms that need no code at all, and on
arm64 that is required.

Isn't Northstar also IPROC? That one didn't seem to need the symbol.

Could you make ARCH_BCM_IPROC a silent symbol that is just selected
by each SoC family specific symbol?

	Arnd

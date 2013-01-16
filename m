Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3APFCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 00:02:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49545 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3APFCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 00:02:33 -0500
Message-ID: <50F63452.1060004@ti.com>
Date: Wed, 16 Jan 2013 10:32:10 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Afzal Mohammed <afzal@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 12/12] video: da8xx-fb: set upstream clock rate (if
 reqd)
References: <cover.1358251447.git.afzal@ti.com> <26e787b021cda89a080f80657c2094b9ff2decaf.1358251448.git.afzal@ti.com> <20130115153222.23734.7924@quantum>
In-Reply-To: <20130115153222.23734.7924@quantum>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/15/2013 9:02 PM, Mike Turquette wrote:
> Quoting Afzal Mohammed (2013-01-15 05:44:36)
>> LCDC IP has a clock divider to adjust pixel clock, this limits pixel
>> clock range to fck/255 - fck/2(fck - rate of input clock to LCDC IP).
>> In the case of AM335x, where this IP is present, default fck is not
>> sufficient to provide normal pixel clock rates, hence rendering this
>> driver unusable on AM335x.
>>
>> If input clock too is configurable, allowable range of pixel clock
>> would increase. Here initially it is checked whether with present fck,
>> divider in IP could be configured to obtain required rate, if not,
>> fck is adjusted. This makes it usable on AM335x.
>>
>> Note:
>> A better (if allowable) solution may be to represent clock divider in
>> LCDC IP as a basic divider clock - the one defined in common clock
>> framework. But for this to happen, all the platform's using this driver
>> should be using common clock framework (DaVinci is yet to be converted
>> to use common clock framework). And it has to be determined whether
>> common clock framework allows this kind of a clock modelling inside a
>> driver and for this to be part of clock tree. Advantage of doing so
>> would be better resolution for pixel clock, even though without this
>> existing use cases are working properly. Or another extreme alternative
>> would be to replicate clk-divider of common clock framework inside the
>> driver, but that probably is not preferred and not worth as it would be
>> duplication and without much advantage to existing users.
>>
> 
> Afzal,
> 
> Modeling the divider inside your IP block as a clock is supported in the
> common clock framework.  Linking up these sorts of clocks to the clock
> tree was one of the original design goals of CCF.
> 
> Regarding DaVinci: converting that platform over to use CCF would be the
> best approach.

This is work in progress. There are patches that have been posted. Work
has been slow on this though due to lack of bandwidth.

> An alternative would be that you could break
> single-image boot for AM335x and DaVinci, by having AM335x use CCF and
> DaVinci use the legacy clock framework.  From the LCDC driver's

Single image for DaVinci and AM335x is not possible anyway since ARMv5
and ARMv6+ cannot be supported in a single image.

> perspective this should not matter and is indeed the purpose of the
> clk.h api and clkdev interfaces, however looking at this driver I can
> see there would still be a lot ifdef-ery going on... better to just
> convert everything over to CCF.

Waiting for DaVinci CCF to complete will be too long a wait. Probably
convert to CCF just for AM335x ATM. There would be some ifdef'ry but
hopefully that need not be inside function bodies. Would have to see the
implementation, I guess.

Thanks,
Sekhar

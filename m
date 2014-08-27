Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbaH0RE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:04:27 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:40803 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaH0REZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:04:25 -0400
Date: Wed, 27 Aug 2014 18:04:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: Re: [RESEND PATCH v3 1/6] charger: max14577: Add support for
 MAX77836 charger
Message-ID: <20140827170416.GC24579@lee--X1>
References: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
 <1409146282-25075-2-git-send-email-k.kozlowski@samsung.com>
 <20140827135218.GG6364@lee--X1>
 <1409148089.25748.5.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409148089.25748.5.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:

> On śro, 2014-08-27 at 14:52 +0100, Lee Jones wrote:
> > On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
> > 
> > > Add support for MAX77836 charger to the max14577 driver. The MAX77836
> > > charger is almost the same as 14577 model except:
> > >  - No dead-battery detection;
> > >  - Support for special charger (like in MAX77693);
> > >  - Support for DX over-voltage protection (like in MAX77693);
> > >  - Lower values of charging current (two times lower current for
> > >    slow/fast charge, much lower EOC current);
> > >  - Slightly different values in ChgTyp field of STATUS2 register. On
> > >    MAX14577 0x6 is reserved and 0x7 dead battery. On the MAX77836 the
> > >    0x6 means special charger and 0x7 is reserved. Regardless of these
> > >    differences the driver maps them to one enum max14577_muic_charger_type.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Anton Vorontsov <anton@enomsg.org>
> > > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > > Cc: David Woodhouse <dwmw2@infradead.org>
> > > Acked-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/power/Kconfig                |  4 +-
> > >  drivers/power/max14577_charger.c     | 77 +++++++++++++++++++++++++++++-------
> > >  include/linux/mfd/max14577-private.h | 54 ++++++++++++++++++-------
> > 
> > Not quite so important here, but better to break these out too.  We
> > can arrange ourselves to that the set can go in together.  Just make
> > sure it's bisectable.
> 
> Are you sure? This will result in a patch which adds some
> code/symbols/defines used only by next (future) patch. Independent apply
> of such patch still won't make any sense because there won't be any user
> of this code.

That's fine.  I take in lots of patches which do nothing more than
adds/updates infrastructure.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

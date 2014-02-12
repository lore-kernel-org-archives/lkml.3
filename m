Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaBLKFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:05:43 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19911 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBLKFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:05:39 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-6e-52fb47728191
Message-id: <1392199536.22265.14.camel@AMDC1943>
Subject: Re: [PATCH 11/14] regulator: s2mps11: Add opmode for S2MPS14 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Date: Wed, 12 Feb 2014 11:05:36 +0100
In-reply-to: <20140212092108.GT15081@lee--X1>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-12-git-send-email-k.kozlowski@samsung.com>
 <20140212092108.GT15081@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xK7pF7r+DDGb8ULHYOGM9q8XUh0/Y
	LK5/ec5qcbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y25xupvV4uKKL0wO3B47Z91l
	99i0qpPN4861PWwe804GevRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGgYY9rAWfhSt6131i
	bGDcx9/FyMkhIWAicfzAI2YIW0ziwr31bF2MXBxCAksZJSbtX8gC4XxmlPh66zQ7SBWvgIHE
	779ngTo4OIQFAiR+dvqDhNkEjCU2L1/CBhIWEVCROPfGHKSVWWAys8ThOV8ZQWpYBFQlNk5f
	wgJicwroSpxpXA41fzmjxMlvfawgCWYBdYlJ8xZBXaQksbu9kx0iLi+xec1bZogbBCV+TL7H
	MoFRYBaSlllIymYhKVvAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyQqvu5gXHrM6hCj
	AAejEg8vg+evICHWxLLiytxDjBIczEoivHddfgcJ8aYkVlalFuXHF5XmpBYfYmTi4JRqYPQS
	O5FcrXzEMEns8ZPXoTm9rLHenFX/RKLZlgprNBWF7p/7hJf1mYhLvFAVk+NNbb2lZ3M8U64l
	uti2fuwMY9rcOFf41x2njcbXitUWv7cvOrv2eXaHbMtLQYlGSz3TNo8XP/zmWYQIhUz9Iydn
	zLVPwm2C2bFeIw+eqasKdtZfDtog+EdTiaU4I9FQi7moOBEAEL4BomgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 09:21 +0000, Lee Jones wrote:
> > S2MPS11/S2MPS14 regulators support different modes of operation:
> >  - Always off;
> >  - On/Off controlled by pin/GPIO (PWREN/LDOEN/EMMCEN);
> >  - Always on;
> > This is very similar to S5M8767 regulator driver which also supports
> > opmodes (although S5M8767 have also low-power mode).
> > 
> > This patch adds parsing the operation mode from DTS by reading a
> > "op_mode" property from regulator child node.
> > 
> > The op_mode is then used for enabling the S2MPS14 regulators.
> > On S2MPS11 the DTS "op_mode" property is parsed but not used for
> > enabling, as this was not tested.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Liam Girdwood <lgirdwood@gmail.com>
> > ---
> >  drivers/regulator/s2mps11.c         |   98 ++++++++++++++++++++++++++++++++++-
> >  include/linux/mfd/samsung/s2mps14.h |   17 ++++++
> >  2 files changed, 114 insertions(+), 1 deletion(-)
> 
> <snip>
> 
> > diff --git a/include/linux/mfd/samsung/s2mps14.h b/include/linux/mfd/samsung/s2mps14.h
> > index c4bfb8edc836..69582ae4c971 100644
> > --- a/include/linux/mfd/samsung/s2mps14.h
> > +++ b/include/linux/mfd/samsung/s2mps14.h
> > @@ -149,4 +149,21 @@ enum s2mps14_regulators {
> >  #define S2MPS14_LDO_N_VOLTAGES	(S2MPS14_LDO_VSEL_MASK + 1)
> >  #define S2MPS14_BUCK_N_VOLTAGES (S2MPS14_BUCK_VSEL_MASK + 1)
> >  
> > +#define S2MPS14_ENCTRL_SHIFT		6
> > +#define S2MPS14_ENCTRL_MASK		(0x3 << S2MPS14_ENCTRL_SHIFT)
> > +
> > +/*
> > + * Values of regulator operation modes match device tree bindings.
> > + */
> > +enum s2mps14_regulator_opmode {
> > +	S2MPS14_REGULATOR_OPMODE_OFF		= 0,
> > +	S2MPS14_REGULATOR_OPMODE_ON		= 1,
> > +	/* Reserved for compatibility with S5M8767 where this
> > +	 * is a low power mode. */
> 
> Sorry to be an arse, but can you use proper multi-line comments
> please?
> 
> The preferred style for long (multi-line) comments is:
> 
>         /*
>          * This is the preferred style for multi-line
>          * comments in the Linux kernel source code.
>          * Please use it consistently.
>          *
>          * Description:  A column of asterisks on the left side,
>          * with beginning and ending almost-blank lines.
>          */

No problem, I'll fix it. The preferred comment in such case had 4 lines
instead of 2 so it looked a little weird to me :).



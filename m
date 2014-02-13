Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaBMNA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:00:58 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10199 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaBMNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:00:56 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-30-52fcc206c2b2
Message-id: <1392296452.14541.7.camel@AMDC1943>
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14
 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Date: Thu, 13 Feb 2014 14:00:52 +0100
In-reply-to: <20140213124320.GB3403@lee--X1>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
 <20140213124320.GB3403@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xK7psh/4EGbTM4bLYOGM9q8XUh0/Y
	LK5/ec5qcbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y25xupvV4uKKL0wO3B47Z91l
	99i0qpPN4861PWwe804GevRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGg8c9bAUPhCoudK5i
	bWD8xNfFyMkhIWAi8eVUNzuELSZx4d56ti5GLg4hgaWMEttuNzNDOJ8ZJdpmzGMBqeIV0Jf4
	8+wGmC0sECpxad0PMJtNwFhi8/IlQN0cHCICKhLn3piD9DILTGaWODznKyNIDYuAqkT/r6Vg
	NZwCOhJLz4SAhIUEVjBKTN8pDWIzC6hLTJq3iBniICWJ3e2d7BBxeYnNa94yQ5wgKPFj8j2W
	CYwCs5C0zEJSNgtJ2QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYITHxZQfj4mNWhxgF
	OBiVeHgtlv0OEmJNLCuuzD3EKMHBrCTC27jtT5AQb0piZVVqUX58UWlOavEhRiYOTqkGxmQb
	2SsvdDTeTTjzu3KqbsJxRa1zaaeNLqw5+47/V+UK3XezutIl92+ZsaovP9Ljlt+UtzcPaWyd
	da7pI0e4hdmaqnNCBefYom8y7TFN7z94/qApbwbPCm3+y+pzp9QfXeiRlhNzTOl14CqTTZsE
	V/qH/J679ce5/lWy+VOdPgXsWeNznKFqdqESS3FGoqEWc1FxIgCp8jMdZwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2014-02-13 at 12:43 +0000, Lee Jones wrote:
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
> >  drivers/regulator/s2mps11.c         |   97 ++++++++++++++++++++++++++++++++++-
> >  include/linux/mfd/samsung/s2mps14.h |   19 +++++++
> >  2 files changed, 115 insertions(+), 1 deletion(-)
> 
> <snip>
> 
> > +++ b/include/linux/mfd/samsung/s2mps14.h
> > @@ -149,4 +149,23 @@ enum s2mps14_regulators {
> >  #define S2MPS14_LDO_N_VOLTAGES		(S2MPS14_LDO_VSEL_MASK + 1)
> >  #define S2MPS14_BUCK_N_VOLTAGES		(S2MPS14_BUCK_VSEL_MASK + 1)
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
> > +	/*
> > +	 * Reserved for compatibility with S5M8767 where this
> > +	 * is a low power mode.
> > +	 */
> > +	S2MPS14_REGULATOR_OPMODE_RESERVED	= 2,
> > +	S2MPS14_REGULATOR_OPMODE_SUSPEND	= 3,
> 
> You don't need to number these like this. If you want to force the
> numbering to start at '0' initialise the top value, then the rest
> should be sequential.

Yes, I know. I wanted to emphasize the relationship to opmode entries in
DTS (to prevent adding new enum value somewhere between them). The code
somehow self-documents that the enum should only be extended, not
modified.

Best regards,
Krzysztof

> 
> > +	S2MPS14_REGULATOR_OPMODE_MAX,
> > +};
> > +
> >  #endif /*  __LINUX_MFD_S2MPS14_H */
> 


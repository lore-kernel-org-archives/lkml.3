Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3KNKx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:53:56 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49881 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3KNKxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:53:54 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-57-5284abc01872
Message-id: <5284ABBF.3080802@samsung.com>
Date: Thu, 14 Nov 2013 11:53:51 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>, Kyungmin Park <kmpark@infradead.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/4] mfd: max14577: Add max14577 MFD driver core
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
 <1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
 <20131113131328.GF878@sirena.org.uk>
 <CAH9JG2U9VDnRW9JZ7j7OyRmVhSXWJ5Yp_gNqUPK=xCST7SY=xg@mail.gmail.com>
 <20131114102419.GE26614@sirena.org.uk>
In-reply-to: <20131114102419.GE26614@sirena.org.uk>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t/xy7oHVrcEGSzq1rA4uFXTYuOM9awW
	Ux8+YbO4/uU5q8X8I+dYLSaunMxsceDPDkaL1y8MLW5dXsVicf/rUUaLb1c6mCwu75rDZnG7
	cQWbxeEVB5gsTnezOvB7LPh8hd1jQv8nRo+ds+6ye2xeoeWxaVUnm8eda3vYPOadDPTo27KK
	0ePzJrkAzigum5TUnMyy1CJ9uwSujDWnd7EWvOCruPylk6WB8R53FyMnh4SAicSqlU/ZIWwx
	iQv31rN1MXJxCAksZZTY8u4LM4TziVHi3JU9bCBVvAJaEqfmXmAFsVkEVCVOH5sLZrMJGEp0
	ve0CqxEVCJVoOLuLEaJeUOLH5HssILaIgKfE4ufbwYYyC7SySBx90Q60moNDWMBF4l9rAUiN
	kMAsJonWm5IgNqeAscTbtSfBZjILmEk8alnHDGHLS2xe85Z5AqPALCQrZiEpm4WkbAEj8ypG
	0dTS5ILipPRcI73ixNzi0rx0veT83E2MkKj6uoNx6TGrQ4wCHIxKPLwFO5uDhFgTy4orcw8x
	SnAwK4nw/lrZEiTEm5JYWZValB9fVJqTWnyIkYmDU6qBceOJp9M2Xpxl8+f2+svFqgv5r6u/
	PJb1yuV08d1/MhnOof03HEIs/mzemFEiKMEZN6l61b5Xuok3Dn/LlfPYnmw0yVvWxXSjtEgD
	42RNKbYvaSYeoectdNbvmPT64iLN7EvHH87aLtq7le+m7wrhq/stfu5X2vb/4XG5jJMX/h/Y
	L1e41FMpjEOJpTgj0VCLuag4EQCN3ljuiAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2013-11-14 11:24, Mark Brown wrote:
> On Thu, Nov 14, 2013 at 10:33:22AM +0900, Kyungmin Park wrote:
> > On Wed, Nov 13, 2013 at 10:13 PM, Mark Brown <broonie@kernel.org> wrote:
>
> > > Are you *positive* this is a falling triggered IRQ?  All the code to do
> > > with spinning reading the GPIO state during handling makes it look like
> > > this is in fact an active low interrupt and a lot of the code in here is
> > > working around trying to handle that as the wrong kind of IRQ.
>
> > It's not work with level triggering. as wm8994, it requires edge
> > triggering. previous time I send RFC patch to handle edge triggering
> > at regmap.
>
> No, wm8994 is level triggered only - the edge triggering stuff there is
> to work around some SoCs that could only support edge triggering and not
> level triggering.  Is this a similar issue or is there something else
> going on, what's the differeence with a level triggered scheme?
>
> > >> +static int __init max14577_i2c_init(void)
> > >> +{
> > >> +     return i2c_add_driver(&max14577_i2c_driver);
> > >> +}
> > >> +subsys_initcall(max14577_i2c_init);
>
> > > Why not module_i2c_driver?
>
> > there's ordering issue, it should provide regulator which is used
> > others before USB probe. if not, it failed to use USB.
> > Other PMICs use also subsys_initcall for this reason.
>
> Modern systems should be able to use deferred probing to resolve these
> dependencies, subsys_initcall() is mostly there for legacy reasons and
> new systems ought to be able to move away from it.

The main problem here is usb gadget subsystem, which simply doesn't support
deferred probe yet. UDC driver (which uses those regulators) need to be
initialized before usb gadget driver (i.e. mass storage or cdc ethernet)
has been registered.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


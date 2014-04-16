Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaDPKoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:44:46 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39542 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbaDPKol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:44:41 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-73-534e5f16bb02
Content-transfer-encoding: 8BIT
Message-id: <1397645078.6147.11.camel@AMDC1943>
Subject: Re: [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 16 Apr 2014 12:44:38 +0200
In-reply-to: <20140416102846.GL4754@lee--X1>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
 <20140416102846.GL4754@lee--X1>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xq7pi8X7BBiuX6lhsnLGe1WLqwyds
	Fte/PGe1ONv0ht3i/tejjBbfrnQwWVzeNYfNYu2Ru+wWtxtXsFmc7mZ14PLYOesuu8emVZ1s
	Hneu7WHzmHcy0KNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyDr/qYi/YoVGxdN4stgbGy/Jd
	jJwcEgImEkeXPGCFsMUkLtxbz9bFyMUhJLCUUeLIz4dgCV4BQYkfk++xdDFycDALyEscuZQN
	EmYWUJeYNG8RM0T9Z0aJxYfusEDU60scur6QDcQWFnCWWHHuKxOIzSZgLLF5+RI2kDkiAioS
	596Yg/QyC3xmktj5cSZYL4uAqsSjRe/B6jkFdCSmbDrACGILCWRK3FmyjR3iUCWJc+vWME5g
	FJiF5LxZCOfNQnLeAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghcfB1B+PSY1aHGAU4
	GJV4eGfk+AYLsSaWFVfmHmKU4GBWEuFtjPQLFuJNSaysSi3Kjy8qzUktPsTIxMEp1cBo/638
	rVhgeWn3W3/GNRdTo8RC33HYv5q/qi5EQi80Vmj1Py+pd5NyPzS/Nf5iffDNhk6m/Yab0r13
	Omz6/WSK8IpA1XnvD3/9VRr/JWq1Pu/X3lvrPr9e/6pePornd7cRY+c0/eYdtXOlJB9ui3Jx
	3q//dE3c/9M/2kIDZbYat17+/eluM6+0EktxRqKhFnNRcSIA6+A3mWECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-04-16 at 11:28 +0100, Lee Jones wrote:
> > This is first part of fifth version of patchset adding support for
> > MAX77836 device to the max14577 driver.
> > 
> > I decided to split the patchset into smaller parts. I hope this would
> > help in getting necessary review/acks from maintainers.
> > 
> > The first part introduces changes in max14577 driver and adds support
> > for MAX77836 in MFD, extcon and regulator drivers. Most of these
> > patches already have required acks from maintainers.
> > Full v4 patchset can be found here:
> > http://thread.gmane.org/gmane.linux.kernel/1654267
> 
> So what's the plan for this driver now? What's missing? Do you have
> all the Acks you need? If so, I'm happy to apply this patch-set and
> supply a pull-request to the other maintainers.

Next patches (part 2):
1. charger: max14577: Add support for MAX77836 charger
2. power: max17040: Add ID for MAX77836 Fuel Gauge block
3. regulator/mfd: max14577: Export symbols for calculating charger 
   current
4. charger: max14577: Configure battery-dependent settings from DTS
5. Documentation: mfd: max14577: Add device tree bindings document
6. regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s

They are quite independent from each other so I think it would be the
best if you could prepare an immutable branch with first part of
patches.

Best regards,
Krzysztof

> 
> > Changes since v4
> > ================
> > 1. Updated Kconfig entries mentioning MAX77836.
> > 2. Removed rename-like patches:
> >    [PATCH v4 02/16] mfd: max14577: Rename and add MAX14577 symbols
> >    [PATCH v4 03/16] mfd: max14577: Rename state container to maxim_core
> > 3. Added new patches (not yet reviewed):
> >    [PATCH v5 2/9] mfd: max14577: Add muic prefix to regmap config
> >    [PATCH v5 6/9] mfd: max14577: Add MAX14577 prefix to IRQ defines
> > 4. Rebased on 3.15-rc1.
> > 
> > Changes since v3
> > ================
> > 1. Applied minor fixes (pointed by Lee Jones).
> > 2. Added one ACK (Lee Jones) and Review-by (Tomasz Figa).
> > 3. Patch 14/charger: Minor change in parsing EOC value from DTS.
> > 4. Rebased on next-20140224.
> > 
> > Changes since v2
> > ================
> > 1. Added ACK-s.
> > 2. Applied minor checkpatch fixes (pointed by Lee Jones).
> > 3. Rebased on next-20140217.
> > 
> > Changes since v1
> > ================
> > 1. Added ACK-s, reviews and tested-by tags.
> > 2. Removed applied patches (they were merged to the linux-next tree).
> > 3. Applied comments from review (Lee Jones) to 5/15 (detection of device type)
> >    and 8/15 (add max77836 support to max14577).
> > 4. Rebased on next tree.
> > 5. Added patch 13 and 14 (pointed by Jenny Tc):
> >    - regulator/mfd: max14577: Export symbols for calculating charger current
> >    - charger: max14577: Configure battery-dependent settings from DTS
> > 6. Updated bindings documentation with new charger bindings.
> > Previous thread:
> >  - [PATCH 00/18] mfd: max14577: Add support for MAX77836
> >    http://thread.gmane.org/gmane.linux.kernel/1636654/focus=1636674
> > 
> > 
> > Description
> > ===========
> > The MAX77836 is almost the same as MAX14577. Basically it is an extended
> > version of MAX14577. The chipsets have same MUIC component so the extcon,
> > charger and regulators require only little adjustments. More changes were
> > needed in the charger (because it uses lower charging current) and regulator
> > drivers (because mentioned different charing current and additional
> > regulators). The MAX77836 has also PMIC and Fuel Gauge (which is the same
> > as MAX17040/17048 Fuel Gauge).
> > 
> > The MAX77836 uses three I2C slave addresses and has additional interrupts
> > (related to PMIC and Fuel Gauge). It has also Interrupt Source register,
> > just like MAX77686 and MAX77693.
> > 
> > 
> > Best regards,
> > Krzysztof Kozlowski
> > 
> > 
> > Chanwoo Choi (1):
> >   extcon: max14577: Change extcon name instead of static name according
> >     to device type
> > 
> > Krzysztof Kozlowski (8):
> >   mfd: max14577: Add muic prefix to regmap config
> >   mfd: max14577: Add detection of device type
> >   extcon: max14577: Add max14577 prefix to muic_irqs
> >   extcon: max14577: Choose muic_irqs according to device type
> >   mfd: max14577: Add MAX14577 prefix to IRQ defines
> >   mfd: max77836: Add MAX77836 support to max14577 driver
> >   extcon: max14577: Add support for MAX77836
> >   regulator: max14577: Add support for MAX77836 regulators
> > 
> >  drivers/extcon/Kconfig               |   4 +-
> >  drivers/extcon/extcon-max14577.c     | 174 +++++++++++++------
> >  drivers/mfd/Kconfig                  |   6 +-
> >  drivers/mfd/max14577.c               | 315 ++++++++++++++++++++++++++++++-----
> >  drivers/regulator/Kconfig            |   7 +-
> >  drivers/regulator/max14577.c         | 277 ++++++++++++++++++++++++++----
> >  include/linux/mfd/max14577-private.h | 222 ++++++++++++++++++------
> >  include/linux/mfd/max14577.h         |  19 ++-
> >  8 files changed, 836 insertions(+), 188 deletions(-)
> > 
> 


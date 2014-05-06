Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbaEFHiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:38:08 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35747 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934110AbaEFHiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:38:03 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fb36d000006ff7-97-53689158538c
Content-transfer-encoding: 8BIT
Message-id: <1399361891.5441.9.camel@AMDC1943>
Subject: Re: [PATCH part2 0/6] charger/mfd: max14577: Part 2 of adding support
 for MAX77836
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 06 May 2014 09:38:11 +0200
In-reply-to: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
References: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xK7oREzOCDT5O0rA4uFXTYuOM9awW
	Ux8+YbOY9OQ9s8XElZOZLc42vWG3uP/1KKPFtysdTBaXd81hs1h75C67xeluVov1M16zOPB4
	TOj/xOixc9Zddo/NK7Q8Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBHFZZOSmpNZllqkb5fA
	ldHxcQFbwRTFivYPPYwNjG8luxg5OSQETCR2b5/NAmGLSVy4t56ti5GLQ0hgKaNE46TNbCAJ
	XgFBiR+T7wEVcXAwC8hLHLmUDRJmFlCXmDRvETNE/WdGiZV9d5lBangF9CQ+Hi0DqREWiJU4
	9L6dCcRmEzCW2Lx8CdhIEYFoidbbvWC7mAX6mCXurdwNlmARUJVYNn0jK8gcTgEPictP7UDC
	QgLuEj/fTGSFuFNZYt7+Y0wTGAVmIbluFsJ1s5Bct4CReRWjaGppckFxUnquoV5xYm5xaV66
	XnJ+7iZGSKR82cG4+JjVIUYBDkYlHt4X0RnBQqyJZcWVuYcYJTiYlUR46/OBQrwpiZVVqUX5
	8UWlOanFhxiZODilGhi1GBf22s+z3ST4bo4FT4f/axubwClbmhnnfYvpFtAseRx26apMstqa
	9ZvrFir//f3hsePLI4GBm7jfc4Te3nu9udPkktXFGdO9L1jxf/tn1Kd0e9/Es8d2Xg+7ZD4n
	/JKAeKZvyY3f4oUBXb9lBFqudWQ+sxBdFx34zT/pkiAvc1j02wcqyRuUWIozEg21mIuKEwF+
	TOB9cgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, David,


I need acks or reviews from power supply subsystem maintainers for
patches:
 - 1/6: charger: max14577: Add support for MAX77836 charger
 - 3/6: charger: max14577: Configure battery-dependent settings from DTS
 - 4/6: power: max17040: Add ID for MAX77836 Fuel Gauge block
These patches were published for the first time around February 2014.


Could you look at them?


Best regards,
Krzysztof


On śro, 2014-04-23 at 16:50 +0200, Krzysztof Kozlowski wrote:
> Hi,
> 
> 
> This is second part of patches adding support for MAX77836 device
> to the max14577 drivers.
> 
> The first part [1] was applied by Lee Jones [2][3] and this patchset *depends*
> on it.
> 
> This patchset changes the max14577 charger and regulator drivers
> and documents Device Tree bindings.
> 
> The patches 1 to 3 depends on each other so they should be pulled at once.
> Patches 4, 5 and 6 can be applied independently. However still the
> smoothest way to apply this would be through one tree after obtaining
> necessary acks from maintainers.
> 
> I need acks from power (patches: 1, 3, 4) and regulator (patch 5) trees.
> 
> 
> Changes since v4 (for this second part only)
> ============================================
> 1. Updated Kconfig entries mentioning MAX77836.
> 2. Added patch 5/6 (regulator: max14577: Implement SUSPEND mode for
>    MAX77836 LDO-s)
> 3. Charger: Require a charger subnode in DTS with charger settings.
>    Previously the charger driver didn't use any properties from DTS.
>    Now it needs a subnode with settings because it supports different
>    devices with different charging characteristics.
> 4. Rebased on 3.15-rc2.
> 
> Changes since v3
> ================
> 1. Applied minor fixes (pointed by Lee Jones).
> 2. Added one ACK (Lee Jones) and Review-by (Tomasz Figa).
> 3. Patch 14/charger: Minor change in parsing EOC value from DTS.
> 4. Rebased on next-20140224.
> 
> Changes since v2
> ================
> 1. Added ACK-s.
> 2. Applied minor checkpatch fixes (pointed by Lee Jones).
> 3. Rebased on next-20140217.
> 
> Changes since v1
> ================
> 1. Added ACK-s, reviews and tested-by tags.
> 2. Removed applied patches (they were merged to the linux-next tree).
> 3. Applied comments from review (Lee Jones) to 5/15 (detection of device type)
>    and 8/15 (add max77836 support to max14577).
> 4. Rebased on next tree.
> 5. Added patch 13 and 14 (pointed by Jenny Tc):
>    - regulator/mfd: max14577: Export symbols for calculating charger current
>    - charger: max14577: Configure battery-dependent settings from DTS
> 6. Updated bindings documentation with new charger bindings.
> 
> 
> References
> ==========
> [1] http://thread.gmane.org/gmane.linux.kernel/1682503
> [2] http://www.spinics.net/lists/kernel/msg1728274.html
> [3] https://git.kernel.org/cgit/linux/kernel/git/lee/mfd.git/log/?h=ib-mfd-extcon-3.16
> 
> Previous, full v4 patchset can be found here:
> http://thread.gmane.org/gmane.linux.kernel/1654267
> 
> 
> Best regards,
> Krzysztof Kozlowski
> 
> 
> Krzysztof Kozlowski (6):
>   charger: max14577: Add support for MAX77836 charger
>   regulator/mfd: max14577: Export symbols for calculating charger
>     current
>   charger: max14577: Configure battery-dependent settings from DTS
>   power: max17040: Add ID for MAX77836 Fuel Gauge block
>   regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
>   devicetree: mfd: max14577: Add device tree bindings document
> 
>  Documentation/devicetree/bindings/mfd/max14577.txt | 152 +++++++++++
>  drivers/mfd/max14577.c                             | 100 ++++++-
>  drivers/power/Kconfig                              |   4 +-
>  drivers/power/max14577_charger.c                   | 291 ++++++++++++++++++---
>  drivers/power/max17040_battery.c                   |   1 +
>  drivers/regulator/max14577.c                       | 139 +++++-----
>  include/linux/mfd/max14577-private.h               |  92 +++++--
>  include/linux/mfd/max14577.h                       |  31 +++
>  8 files changed, 673 insertions(+), 137 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbaCRNKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:10:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32547 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaCRNKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:10:36 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-10-532845ca5510
Content-transfer-encoding: 8BIT
Message-id: <1395148233.24909.2.camel@AMDC1943>
Subject: Re: [GIT PULL] mfd: regulator: S2MPA01 device support IB for Mark Brown
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org,
        broonie@kernel.org, devicetree@vger.kernel.org
Date: Tue, 18 Mar 2014 14:10:33 +0100
In-reply-to: <20140318110947.GR25478@lee--X1>
References: <1394797919-24642-1-git-send-email-sachin.kamat@linaro.org>
 <20140318110947.GR25478@lee--X1>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t/xa7qnXDWCDVa0SFlMffiEzWL+kXOs
	Fve/HmW0uLxrDpvFyT+9jA6sHptWdbJ53Lm2h83j8ya5AOYoLpuU1JzMstQifbsEroyWacUF
	TeIVpyc0sjUwPhPsYuTkkBAwkTi7fjkjhC0mceHeerYuRi4OIYGljBJXtt1jBknwCghK/Jh8
	j6WLkYODWUBe4silbJAws4C6xKR5i8BKhAQ+M0p8eukHUa4v0bvkNguILSwQIHF4WwsriM0m
	YCyxefkSNpAxIgIqEufemEOMqZJ4MnkCO4jNIqAq8fPPNiYQm1NAV+LFglVQ47Mktn39B3Wm
	ksTu9k72CYwCs5AcNwvhuFlIjlvAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyRov+5g
	XHrM6hCjAAejEg/vSzb1YCHWxLLiytxDjBIczEoivOxWGsFCvCmJlVWpRfnxRaU5qcWHGJk4
	OKUaGMWdjNPnVyxk/fZoouyKS4233h5pmxPid+nEtLykN68+x3JwX3D7pS44O+To3fAn+a+F
	RX01JimGl1p3NDLMOvTB8uIT3aC8xt9v15hefV2U91ftkXYA/0PPMtkftcWy32rjLXdfeCW7
	zSVCOHN7j8GBuSuE/zAfj71+Ubpb5a83/xT3St2ebUosxRmJhlrMRcWJAAsWH3c4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems that Sachin's and my patches (mfd: sec: Add support for
S2MPS14) are not in sync. Now the error appears:

drivers/mfd/sec-core.c:342:45: warning: ‘regmap_rtc’ may be used
uninitialized in this function [-Wuninitialized]

I'll send a quick fix for it but in a longterm the rtc-s5m driver should
initialize his regmap on his own.

Best regards,
Krzysztof

O
n Tue, 2014-03-18 at 11:09 +0000, Lee Jones wrote:
> FAO Mark,
> 
> The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:
> 
>   Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git ib-mfd-regulator-3.15
> 
> for you to fetch changes up to ba3e31f87e8b736adf01f1dc09cd5618966ee193:
> 
>   Documentation: mfd: Add binding document for S2MPA01 (2014-03-18 10:56:45 +0000)
> 
> ----------------------------------------------------------------
> Krzysztof Kozlowski (5):
>       mfd: sec-core: Add maximum RTC register for regmap config
>       mfd: sec-core: Select different RTC regmaps for devices
>       mfd: sec-irq: Use consistent S2MPS11 RTC alarm interrupt indexes
>       mfd: sec: Add support for S2MPS14
>       mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error
> 
> Pankaj Dubey (1):
>       mfd: sec-core: Silence compiler warning
> 
> Sachin Kamat (3):
>       mfd: Add support for S2MPA01 device
>       regulator: Add support for S2MPA01 regulator
>       Documentation: mfd: Add binding document for S2MPA01
> 
>  Documentation/devicetree/bindings/mfd/s2mpa01.txt |  90 ++++++++++++++++++++++++++
>  drivers/mfd/sec-core.c                            | 112 +++++++++++++++++++++++++++++---
>  drivers/mfd/sec-irq.c                             |  97 ++++++++++++++++++++++++++--
>  drivers/regulator/Kconfig                         |   7 ++
>  drivers/regulator/Makefile                        |   1 +
>  drivers/regulator/s2mpa01.c                       | 481 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/samsung/core.h                  |  19 ++++--
>  include/linux/mfd/samsung/irq.h                   |  81 +++++++++++++++++++++++-
>  include/linux/mfd/samsung/rtc.h                   |  57 +++++++++++++++--
>  include/linux/mfd/samsung/s2mpa01.h               | 192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/samsung/s2mps14.h               | 152 ++++++++++++++++++++++++++++++++++++++++++++
>  11 files changed, 1260 insertions(+), 29 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/s2mpa01.txt
>  create mode 100644 drivers/regulator/s2mpa01.c
>  create mode 100644 include/linux/mfd/samsung/s2mpa01.h
>  create mode 100644 include/linux/mfd/samsung/s2mps14.h
> 


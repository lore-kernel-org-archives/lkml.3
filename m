Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaBCK0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:26:44 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49552 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBCK0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:26:43 -0500
Date: Mon, 3 Feb 2014 10:26:37 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 16/18] charger: max14577: Add support for MAX77836 charger
Message-ID: <20140203102637.GO13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-17-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390911522-28209-17-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Krzysztof Kozlowski wrote:

> Add support for MAX77836 charger to the max14577 driver. The MAX77836
> charger is almost the same as 14577 model except:
>  - No dead-battery detection;
>  - Support for special charger (like in max77693);
>  - Support for DX over-voltage protection (like in max77693);
>  - Lower values of charging current (two times lower current for
>    slow/fast charge, much lower EOC current);
>  - Slightly different values in ChgTyp field of STATUS2 register. On
>    MAX14577 0x6 is reserved and 0x7 dead battery. On the MAX77836 the
>    0x6 means special charger and 0x7 is reserved. Regardless of these
>    differences the driver maps them to one enum maxim_muic_charger_type.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---
>  drivers/extcon/extcon-max14577.c     |    2 +-
>  drivers/power/max14577_charger.c     |   81 +++++++++++++++++++++++++++-------
>  include/linux/mfd/max14577-private.h |   57 +++++++++++++++++-------
>  3 files changed, 106 insertions(+), 34 deletions(-)

For the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaFEPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:16:56 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:60133 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaFEPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:16:55 -0400
Date: Thu, 5 Jun 2014 16:16:50 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-pm@vger.kernel.org, eduardo.valentin@ti.com, rui.zhang@intel.com
Subject: Re: [STLinux Kernel] [PATCH 3/6] thermal: sti: Add support for ST's
 System Config Register based Thermal controller
Message-ID: <20140605151650.GB7446@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401442715-6350-1-git-send-email-lee.jones@linaro.org>
 <1401442715-6350-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401442715-6350-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

See my comments below: -

> +/* STiH416 */
> +#define STIH416_SYSCFG_FRONT(num)		((num - 1000) * 4)
> +#define STIH416_SAS_THSENS_CONF			STIH416_SYSCFG_FRONT(1552)
> +#define STIH416_SAS_THSENS_STATUS1		STIH416_SYSCFG_FRONT(1554)
> +#define STIH416_SAS_THSENS_STATUS2		STIH416_SYSCFG_FRONT(1594)
> +
> +/* STiD127 */
> +#define STID127_SYSCFG_CPU(num)			((num - 700) * 4)
> +#define STID127_THSENS_CONF			STID127_SYSCFG_CPU(743)
> +#define STID127_THSENS_STATUS			STID127_SYSCFG_CPU(767)

There is no upstream support for STiD127 SoC AFAIK? I think this should be removed
from the driver and just keep stih415 / stih416 parts.

Also a seperate somewhat unrelated question... stih415 and stih416 are very similar 
dual die parts. Do you know why the stih415 has support for sas & mpe die temperature
sensors, but the stih416 only has support for the sas die?

Regards,

Peter


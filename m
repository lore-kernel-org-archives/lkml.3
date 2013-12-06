Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3LFPkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:40:14 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:42435 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3LFPkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:40:12 -0500
Date: Fri, 6 Dec 2013 15:40:06 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, dev@lynxeye.de,
        lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] regulator: tps6586x: add and use correct voltage
 table
Message-ID: <20131206154006.GE23519@lee--X1>
References: <cover.1386333697.git.stefan@agner.ch>
 <7c948660cda4684d28fa97f82295ab84f6ef658e.1386333697.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c948660cda4684d28fa97f82295ab84f6ef658e.1386333697.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Dec 2013, Stefan Agner wrote:

> Depending on the regulator version, the voltage table might be
> different. Use version specific regulator tables in order to select
> correct voltage table. For the following regulator versions different
> voltage tables are now used:
> 
>   * TPS658623: Use correct voltage table for SM2
>   * TPS658643: New voltage table for SM2
> 
> Both versions are in use on the Colibri T20 module. Make use of the
> correct tables by requesting the correct SM2 voltage of 1.8V.
> 
> This change is not backward compatible since an old driver is not able
> to correctly set that value. The value 1.8V is out of range for the old
> driver and will refuse to probe the device. The regulator starts with
> default settings and the driver shows appropriate error messages.
> 
> On Colibri T20, the old value used to work with TPS658623 since the
> driver applied a wrong voltage table too. However, the TPS658643 used
> on V1.2 devices uses yet another voltage table and those broke that
> pseudo-compatibility. The regulator driver now has the correct voltage
> table for both regulator versions and those the correct voltage can be
> used in the device tree.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> Changes since v3:
>   - Check if version specific table is necessary
> 
> Changes since v2:
>   - Removed reg_ from reg_version
>   - Moved walk through version dependent tables to find_regulator_info,
>     removed the inline definition. This reduces .o size and encapsulates
>     the logic of finding the right regulator into one function. It comes
>     with a slight code duplication, the table search now appears twice.
> ---
>  arch/arm/boot/dts/tegra20-colibri-512.dtsi |  4 +-
>  drivers/regulator/tps6586x-regulator.c     | 93 ++++++++++++++++++++++++-----

Applied with Reviews and Acks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

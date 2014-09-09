Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaIICh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:37:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49867 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbaIIChz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:37:55 -0400
Date: Tue, 9 Sep 2014 10:37:40 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-gpio@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
        linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 0/2] Support CrystalCove PMIC ACPI operation region
Message-ID: <20140909023658.GA11705@aaronlu.sh.intel.com>
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to cc linux-acpi in the last series so please reply to this
thread, sorry for the inconvenience.

Regards,
Aaron

On Tue, Sep 09, 2014 at 10:32:46AM +0800, Aaron Lu wrote:
> The two patches add support for CrystalCove PMIC ACPI operation region.
> The PMIC chip has two customized operation regions: one for power rail
> manipulation and one for thermal purpose: sensor temperature reading
> and trip point value reading/setting.
> 
> For an example ASL code on ASUS T100 with CrystalCove PMIC, see here:
> https://gist.github.com/aaronlu/f5f65771a6c3251fae5d
> 
> Aaron Lu (2):
>   gpio / CrystalCove: support virtual GPIO
>   PMIC / opregion: support PMIC customized operation region for
>     CrystalCove
> 
>  drivers/gpio/gpio-crystalcove.c           |  19 +-
>  drivers/mfd/Kconfig                       |  11 +
>  drivers/mfd/Makefile                      |   1 +
>  drivers/mfd/intel_soc_pmic_crc.c          |   3 +
>  drivers/mfd/intel_soc_pmic_crc_opregion.c | 229 +++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_opregion.c     | 350 ++++++++++++++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_opregion.h     |  35 +++
>  include/asm-generic/gpio.h                |   2 +-
>  8 files changed, 646 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/mfd/intel_soc_pmic_crc_opregion.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_opregion.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_opregion.h
> 
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

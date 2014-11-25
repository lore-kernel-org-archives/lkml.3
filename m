Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaKYB0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:26:08 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53143 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751195AbaKYB0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:26:05 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yegnesh Iyer <yegnesh.s.iyer@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Support PMIC operation region for CrystalCove and XPower
Date: Tue, 25 Nov 2014 02:47:18 +0100
Message-ID: <1987897.BgdIEqPdlH@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416553911-22990-1-git-send-email-aaron.lu@intel.com>
References: <1416553911-22990-1-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 21, 2014 03:11:48 PM Aaron Lu wrote:
> v3:
> Only some function/variable name changes, no functiona changes:
> - Replace the dptf/DPTF word originate from the BIOS ACPI table with more
>   meaningful word thermal/THERMAL in all places;
> - Eliminate the soc part in various structure and function names to make
>   them shorter:
>   intel_soc_pmic_opregion -> intel_pmic_opregion
>   intel_soc_pmic_pmop_handler -> intel_pmic_pmop_handler
>   intel_soc_pmic_install_opregion_handler -> intel_pmic_install_opregion_handler
>   etc.
> 
> 
> v2:
> Place PMIC operation files under drivers/acpi/pmic instead of
> drivers/acpi/pmic_opregion as suggested by Rafael;
> Rename PMIC operation files to make them shorter as suggested by Rafael.
> 
> v1:
> On Intel Baytrail-T and Baytrail-T-CR platforms, there are two customized
> ACPI operation regions defined for the Power Management Integrated Circuit
> device, one is for power resource handling and one is for thermal: sensor
> temperature reporting, trip point setting, etc. There are different PMIC
> chips used on those platforms and though each has the same two operation
> regions and functionality, their implementation is different so every PMIC
> will need a driver. But since their functionality is similar, some common
> code is abstracted into the intel_soc_pmic_opregion.c.
> 
> The last version is posted here:
> https://lkml.org/lkml/2014/9/8/801
> 
> Changes since then:
> 1 Move to drivers/acpi as discussed on the above thread;
> 2 Added support for XPower AXP288 PMIC operation region support;
> 3 Since operation region handler can not be removed(at the moment at least),
>   use bool for the two operation region driver configs instead of tristate;
>   Another reason to do this is that, with Mika's MFD ACPI support patch, all
>   those MFD cell devices created will have the same modalias as their parent's
>   so it doesn't make much sense to compile these drivers into modules.
> 
> Patch 1 applies on top of Rafael's pm-next branch, and then patch 2 and
> patch 3 needs merge of Lee's mfd/ib-mfd-iio-3.19 branch where the PMIC
> driver XPower AXP288 and iio driver axp288_adc is located.
> 
> 
> Aaron Lu (3):
>   ACPI / PMIC: support PMIC operation region for CrystalCove
>   ACPI / PMIC: support PMIC operation region for XPower AXP288
>   ACPI / PMIC: AXP288: support virtual GPIO in ACPI table

OK

I've pulled the Lee's 'mfd/ib-mfd-iio-3.19' branch and applied your updated
three on top of that.  Please check the bleeding-edge branch of linux-pm.git
for the result.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

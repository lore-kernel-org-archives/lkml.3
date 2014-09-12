Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaILTgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:36:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:21727 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbaILTgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:36:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="385418239"
Date: Fri, 12 Sep 2014 12:36:45 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v3 0/5] Initial support for XPowers AXP288 PMIC
Message-ID: <20140912123645.3bc6058f@ultegra>
In-Reply-To: <20140912151824.GU31276@lukather>
References: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<20140912151824.GU31276@lukather>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 17:18:24 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> On Thu, Sep 11, 2014 at 04:15:52PM -0700, Jacob Pan wrote:
> > XPowers AXP288 is a customized PMIC found on some Intel Baytrail-CR
> > platforms. It comes with sub-functions such as USB charging, fuel
> > gauge, ADC, and many LDO and BUCK channels.
> > 
> > By extending the existing AXP20x driver, this patchset adds basic
> > support for AXP288 PMIC with GPADC as one MFD cell device driver.
> > It also adds hooks for ACPI opregion handler driver which can be
> > used to handle ACPI requests.
> > 
> > Currently, the PMIC driver in this patchset does not support
> > platform data enumeration. But when ACPI _DSD and unified device
> > properties become available, cell devices with platform data will
> > be added.
> > 
> > This patch does not use intel_soc_pmic core for i2c and regmap
> > handling in that axp288 shares similar programming interface with
> > other Xpower PMICs supported in axp20x.c. Therefore, extending
> > axp20x.c to include axp288 makes more sense.
> > 
> > Changes
> >  v3:	- put all file rename changes in 1/5
> 
> The variables renaming are still not in 1/5....
> 
1/5 is for file rename such that the follow up patches are more
readable. There are so many details in variable rename, I think it
belongs to the patch that expands the new device support.

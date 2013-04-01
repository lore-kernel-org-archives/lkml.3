Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3DANWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:22:32 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49410 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab3DANWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:22:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] ACPI / SPI: Use parent's ACPI_HANDLE() in acpi_register_spi_devices()
Date: Mon, 01 Apr 2013 15:30:05 +0200
Message-ID: <3094287.rEsFgshmOE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130401114422.GA18636@opensource.wolfsonmicro.com>
References: <2747891.0orCNBJG8v@vostro.rjw.lan> <20130401114422.GA18636@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 01, 2013 12:44:23 PM Mark Brown wrote:
> On Mon, Apr 01, 2013 at 02:21:08AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The ACPI handle of struct spi_master's dev member should not be
> > set, because this causes that struct spi_master to be associated
> > with the ACPI device node corresponding to its parent as the
> > second "physical_device", which is incorrect (this happens during
> > the registration of struct spi_master).  Consequently,
> > acpi_register_spi_devices() should use the ACPI handle of the
> > parent of the struct spi_master it is called for rather than that
> > struct spi_master's ACPI handle (which should be NULL).
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> or does this need to be applied to the SPI tree?

I can push it through the PM/ACPI tree along with an analogous I2C patch.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaAVM1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:27:06 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44855 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932096AbaAVM1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:27:02 -0500
Date: Wed, 22 Jan 2014 12:26:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig errors
Message-ID: <20140122122653.GA15937@n2100.arm.linux.org.uk>
References: <CA+V-a8vcvTRpP-cE6SKd1KgWgzSbOXvSNW+5Jh8wqOfr1za4SQ@mail.gmail.com> <CA+V-a8uy6wM8nS993VeezJGOaoqM5GRsJE7FrKe7=bhD6nZhXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8uy6wM8nS993VeezJGOaoqM5GRsJE7FrKe7=bhD6nZhXw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 05:54:29PM +0530, Prabhakar Lad wrote:
> Hi Russell,
> 
> On Fri, Jan 17, 2014 at 1:07 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
> > Hi,
> >
> > On Linux-next branch I see following errors for davinci_all_defconfig
> > & da8xx_omapl_defconfig configs,
> >
> > arch/arm/Kconfig:1966:error: recursive dependency detected!
> > arch/arm/Kconfig:1966:    symbol ZBOOT_ROM depends on AUTO_ZRELADDR
> > arch/arm/Kconfig:2154:    symbol AUTO_ZRELADDR is selected by ZBOOT_ROM
> > #
> > # configuration written to .config
> > #
> >
> I am seeing this errors on linux-next, with your recent patch,
> "[PATCH] Fix select-induced Kconfig warning for ZBOOT_ROM"
> and strangely I see that AUTO_ZRELADDR doesnt select ZBOOT_ROM
> but still an error.
> 
> Note: For the davinci configs CONFIG_AUTO_ZRELADDR is not set and
> CONFIG_ZBOOT_ROM_TEXT=0x0, CONFIG_ZBOOT_ROM_BSS=0x0

I've killed off the "select AUTO_ZRELADDR if !ZBOOT_ROM" in the IMX
Kconfig now, so when linux-next picks up my tree, that should be gone.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".

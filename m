Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaAMVWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:22:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57196 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaAMVWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:22:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] Driver/IFC: Move Freescale IFC driver to a common driver
Date: Mon, 13 Jan 2014 22:22:12 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Prabhakar Kushwaha <prabhakar@freescale.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <1389590671-20289-1-git-send-email-prabhakar@freescale.com> <201401132045.44063.arnd@arndb.de> <1389643828.24905.80.camel@snotra.buserror.net>
In-Reply-To: <1389643828.24905.80.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401132222.12572.arnd@arndb.de>
X-Provags-ID: V02:K0:1znFc54QrzUDZjwo+TvSdLTRefFymvifmdHlZ9s/XWI
 wvj81bcG55I7bc8Aps7XzMKtPSvxSwvTe8cFHxAJ1gOpAGUN0S
 1f+fkgJnezQPCNkJTQPyZzdZKfvB54x70t9CO5VKiYsQnsngPd
 DxvM03tgCQoKrvQ3X9b7Qrq26LMrI8Rb+JufGI8MK6c+ppBbQO
 vZz2kt50tYewrW0ehe2wIMVPgSW8NoBDgCdF587weWGR6gZhog
 GoMKYWBtSIIy6+uevFTfmLTvWUgcH1cJNA9WKENeOGILLpeHXi
 Jaxdy1XTuX5i/vMgGsLSZP/wNauJ+9IQc1PJ4eBtPQrBkaLRIT
 AMi1P5QQ5cnUG8WqwoIs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 January 2014, Scott Wood wrote:
> On Mon, 2014-01-13 at 20:45 +0100, Arnd Bergmann wrote:
> > On Monday 13 January 2014, Scott Wood wrote:
> > > On Mon, 2014-01-13 at 14:32 +0100, Arnd Bergmann wrote:
> > > > On Monday 13 January 2014, Prabhakar Kushwaha wrote:
> > > > > Freescale IFC controller has been used for mpc8xxx. It will be used
> > > > > for ARM-based SoC as well. This patch moves the driver to driver/misc
> > > > > and fix the header file includes.
> > > > > 
> > > > > Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
> > > > 
> > > > No objections to the driver, but drivers/misc doesn't seem like the
> > > > right place. Why not drivers/mfd or drivers/memory?
> > > 
> > > It's not a memory controller in the sense that I think most people would
> > > interpret the phrase, but I guess it's similar in function to
> > > mvebu-devbus.  If drivers/memory is broad enough to cover such things,
> > > and doesn't have a memory controller subsystem that drivers are supposed
> > > to register with, then that could work.
> > > 
> > > Are things in drivers/mfd expected to interact with mfd-core.c?  It's
> > > not clear to me what that does or how it would be useful to the IFC
> > > code.
> > 
> > Sorry, I meant mtd not mfd. mtd would make sense if the only devices
> > behind it are things like flash or sram memory.
> 
> Some of the things behind it are flash, but those portions of the driver
> are already in drivers/mtd.  This is just the common code.
> 

What are the things that are not flash then?

	Arnd

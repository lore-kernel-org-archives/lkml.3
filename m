Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936172Ab3DIHVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:21:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:26944 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762938Ab3DIHVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:21:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,436,1363158000"; 
   d="scan'208";a="316425616"
Date: Tue, 9 Apr 2013 09:20:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20130409072059.GC23447@zurbaran>
References: <20130408142124.ac540429a889cdc9800e529a@canb.auug.org.au>
 <1365396351.542317232@f36.mail.ru>
 <20130408092243.GK24058@zurbaran>
 <1365438469.322553103@f51.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1365438469.322553103@f51.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Mon, Apr 08, 2013 at 08:27:49PM +0400, Alexander Shiyan wrote:
> > > > After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> > > > failed like this:
> > > > 
> > > > drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
> > > > drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of function 'of_get_parent' [-Werror=implicit-function-declaration]
> > > > 
> > > > Caused by commit 5ab3a89a741f ("mfd: syscon: Add non-DT support").
> > > > 
> > > > I have used the mfd tree from next-20130405 for today.
> > > 
> > > This means that we do not have empty declarations for the
> > > of_xx functions in linux/of.h for !CONFIG_OF.
> > > OK to declare these functions or any other opinions?
> > Ok with me, but you'd need to get Grant and Rob's ACK.
> 
> I've revised my initial opinion and write ​​a quick patch for fix this issue.
> 
> From a884d309d2978cbc44c52b650d669e56fef664e2 Mon Sep 17 00:00:00 2001
> From: Alexander Shiyan <shc_work@mail.ru>
> Date: Mon, 8 Apr 2013 19:13:10 +0400
> Subject: [PATCH] regulator: anatop: Make select dependency from
>  HAVE_IMX_ANATOP symbol
> 
> This patch make selection of anatop-regulator from HAVE_IMX_ANATOP
> kernel symbol. This fixes build kernel with syscon driver but without
> oftree support.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/regulator/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index a5d97ea..078932d 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -133,7 +133,7 @@ config REGULATOR_FAN53555
>  
>  config REGULATOR_ANATOP
>  	tristate "Freescale i.MX on-chip ANATOP LDO regulators"
> -	depends on MFD_SYSCON
> +	depends on HAVE_IMX_ANATOP
This does look like a band-aid solution to me. Yes, it will fix the crash, but
you're restricting this code to a much smaller architecture set. AFAIK
linux-next is not tested on that arch, for example.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3BEQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:27:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3BEQ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:27:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform drivers
Date: Tue, 5 Feb 2013 16:27:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Felipe Balbi <balbi@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linux-usb@vger.kernel.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <20130121184138.GB10106@arwen.pp.htv.fi> <20130121185716.GA26754@kroah.com>
In-Reply-To: <20130121185716.GA26754@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051627.18337.arnd@arndb.de>
X-Provags-ID: V02:K0:ktKYYsHQfMg5PiefMIqEdxjJQbaeHQb2nHbUZjOK0KK
 pr/881hsPGXyqRAHBzBKi6t6WT//CcYaV/ET434TzKb/cuq/Oh
 ebBTl3dLYSRW7i4ri/X2j1Gcfn3Mamp0EDuVnLATeh1ZCc47uu
 QhsWnxQO5dMSrIIIJC9n5odbd258IQ0p72F6287Skpv3zIdvn7
 pIJJYRyRX0JIehXxYUpj6QJNs7IeTihux+EBHmIkpkY6XOudFB
 tF4E0O5f2OkMO0YNP9EPqOXeU4nwGWicCzH1XEegEDbXC4itWE
 3vVQtUIxEYARitfJayspA46EA1soNABOC5UEKv4PzHHf/fTM50
 dYyTQV3D779ut00CdT+g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Greg Kroah-Hartman wrote:
> On Mon, Jan 21, 2013 at 08:41:38PM +0200, Felipe Balbi wrote:
> > Hi,
> > 
> > On Mon, Jan 21, 2013 at 05:16:05PM +0000, Arnd Bergmann wrote:
> > > Both the fsl_mxc gadget and the imx_udc gadget drivers fail to build
> > > without the mach/hardware.h file that is not available when building
> > > for multiplatform. Let's disable these drivers for v3.8 in combination
> > > with CONFIG_ARCH_MULTIPLATFORM, and fix them properly in v3.9 unless
> > > someone has an better solution.
> > > 
> > > Without this patch, building allyesconfig results in:
> > > 
> > > drivers/usb/gadget/fsl_mxc_udc.c:21:27: fatal error: mach/hardware.h: No such file or directory
> > > 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Felipe Balbi <balbi@ti.com>
> > > Cc: Shawn Guo <shawn.guo@linaro.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: linux-usb@vger.kernel.org
> > 
> > NAK, I prefer to see a real fix for the problem (which in fact is
> > already in my fixes branch).
> 
> I'll pull that branch now, sorry for the delay.

Apparently it hasn't made it into the upstream kernel yet, and it also doesn't
seem to be in linux-next. Maybe this got lost while you were travelling?

	Arnd

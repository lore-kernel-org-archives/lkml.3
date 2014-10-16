Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaJPHwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:52:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26775 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJPHwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:52:24 -0400
Date: Thu, 16 Oct 2014 10:52:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] bcm/CmHost.c: Fix noisy compile warnings
Message-ID: <20141016075211.GE23154@mwanda>
References: <1413399701-4321-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20141015195549.GR26918@mwanda>
 <1413404767.2412.31.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413404767.2412.31.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 01:26:07PM -0700, Jeff Kirsher wrote:
> On Wed, 2014-10-15 at 22:55 +0300, Dan Carpenter wrote:
> > On Wed, Oct 15, 2014 at 12:01:41PM -0700, Jeff Kirsher wrote:
> > > From: Fabio Estevam <fabio.estevam@freescale.com>
> > > 
> > > The Beceem WIMAX was generating compile warnings on 64bit machines,
> > > which were:
> > > 
> > > drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
> > > drivers/staging/bcm/CmHost.c:1503:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> > >    (struct bcm_connect_mgr_params *) ntohl(
> > >    ^
> > > drivers/staging/bcm/CmHost.c:1546:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> > >    (struct bcm_connect_mgr_params *) ntohl(
> > >    ^
> > > drivers/staging/bcm/CmHost.c:1564:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> > >    (struct bcm_connect_mgr_params *) ntohl(
> > > 
> > > This resolves the issue by preventing the driver to compile if CONFIG_64BIT
> > > is enabled, since the driver is known to be broken for 64 bit arch's.
> > > 
> > 
> > Oops.  Someone turned a Joe patch into a real patch.  Please enable
> > COMPILE_TEST for this.
> 
> I agree with Joe, that COMPILE_TEST is not useful for this driver.

If we remove the driver fine, but if we keep the driver then we should
do enable any QA testing we can.

regards,
dan carpenter


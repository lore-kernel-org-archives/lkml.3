Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaJPIOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:14:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaJPIOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:14:12 -0400
Date: Thu, 16 Oct 2014 10:13:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] bcm/CmHost.c: Fix noisy compile warnings
Message-ID: <20141016081307.GB9298@kroah.com>
References: <1413399701-4321-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1413413961.2412.40.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413413961.2412.40.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 03:59:21PM -0700, Jeff Kirsher wrote:
> On Wed, 2014-10-15 at 12:01 -0700, Jeff Kirsher wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > The Beceem WIMAX was generating compile warnings on 64bit machines,
> > which were:
> > 
> > drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
> > drivers/staging/bcm/CmHost.c:1503:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >    (struct bcm_connect_mgr_params *) ntohl(
> >    ^
> > drivers/staging/bcm/CmHost.c:1546:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >    (struct bcm_connect_mgr_params *) ntohl(
> >    ^
> > drivers/staging/bcm/CmHost.c:1564:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >    (struct bcm_connect_mgr_params *) ntohl(
> > 
> > This resolves the issue by preventing the driver to compile if CONFIG_64BIT
> > is enabled, since the driver is known to be broken for 64 bit arch's.
> > 
> > CC: Dan Carpenter <dan.carpenter@oracle.com>
> > CC: Joe Perches <joe@perches.com>
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> 
> Greg- I have also submitted a patch to remove this driver entirely.  So
> if you choose to apply the patch to remove the driver, then you can
> disregard this patch.

Thanks, I'll take that removal patch now, I'm glad to get rid of that
mess.

greg k-h

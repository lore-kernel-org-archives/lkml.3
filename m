Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3LaOvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 09:51:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37004 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3LaOvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 09:51:11 -0500
Date: Tue, 31 Dec 2013 09:50:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow xenfb initialization for hvm guests
Message-ID: <20131231145001.GA3349@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312171738550.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 05:53:13PM +0000, Stefano Stabellini wrote:
> There is no reasons why an HVM guest shouldn't be allowed to use xenfb.
> As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
> Given that no Xen toolstacks configure a xenfb backend for x86 HVM
> guests, they are not affected.

Could you reference the upstream git commit that enables this.

And also CC the maintainers of drivers/video/*

And lastly lets CC also David and Boris on it.

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
> index cd005c2..02e1c01 100644
> --- a/drivers/video/xen-fbfront.c
> +++ b/drivers/video/xen-fbfront.c
> @@ -692,7 +692,7 @@ static DEFINE_XENBUS_DRIVER(xenfb, ,
>  
>  static int __init xenfb_init(void)
>  {
> -	if (!xen_pv_domain())
> +	if (!xen_domain())
>  		return -ENODEV;
>  
>  	/* Nothing to do if running in dom0. */

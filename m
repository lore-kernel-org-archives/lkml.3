Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaEZSbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:31:40 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:64746 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaEZSbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:31:38 -0400
Date: Mon, 26 May 2014 20:31:55 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] driver core/platform: don't leak memory allocated
 for dma_mask
Message-ID: <20140526183155.GA1312@lianli>
References: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
 <20140526165105.GD3693@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526165105.GD3693@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Mon, May 26, 2014 at 05:51:05PM +0100, Russell King - ARM Linux wrote:
> On Mon, May 26, 2014 at 06:41:21PM +0200, Emil Goode wrote:
> > @@ -211,6 +215,7 @@ struct platform_device *platform_device_alloc(const char *name, int id)
> >  		strcpy(pa->name, name);
> >  		pa->pdev.name = pa->name;
> >  		pa->pdev.id = id;
> > +		pa->pdev.dev.dma_mask = &pa->dma_mask;
> 
> There is code in the kernel which, rightly or wrongly, checks whether
> dev->dma_mask is NULL to determine whether the device can do any kind
> of DMA.  The above results in devices allocated via this interface
> always having this member set, which is a change of core kernel behaviour.
> 
> How sure are you that this will not break anything?

Thank you for pointing this out, considering the number of calls made to
platform_device_alloc it would be easy to miss an occurrance of this problem.
I would say that the risk heavily outweighs the gain and it's better to 
not apply this series.

Best regards,

Emil Goode

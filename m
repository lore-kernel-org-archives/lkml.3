Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab3LKKMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:12:47 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:39429 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3LKKMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:12:45 -0500
Message-ID: <1386756675.16289.37.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v4 01/15] usb: phy: msm: Move mach dependent code to
 platform data
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: davidb@codeaurora.org
Cc: balbi@ti.com, gregkh@linuxfoundation.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@fifo99.com>
Date: Wed, 11 Dec 2013 12:11:15 +0200
In-Reply-To: <1384267910-32066-2-git-send-email-iivanov@mm-sol.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
	 <1384267910-32066-2-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2013-11-12 at 16:51 +0200, Ivan T. Ivanov wrote: 
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> This patch fix compilation error when driver is compiled
> in multi-platform builds.
> 
> drivers/built-in.o: In function `msm_otg_link_clk_reset':
> ./drivers/usb/phy/phy-msm-usb.c:314: undefined reference to `clk_reset'
> ./drivers/usb/phy/phy-msm-usb.c:318: undefined reference to `clk_reset'
> 
> Use platform data supplied reset handlers and adjust error
> messages reported when reset sequence fail.
> 
> This is an intermediate step before adding support for reset
> framework and newer targets.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Acked-by: David Brown <davidb@codeaurora.org>


David, could you take this change trough your tree?

Thanks, Ivan


> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/arm/mach-msm/board-msm7x30.c |   35 +++++++++++++++++++++++++++++++++++
>  arch/arm/mach-msm/board-qsd8x50.c |   35 +++++++++++++++++++++++++++++++++++
>  drivers/usb/phy/phy-msm-usb.c     |   35 +++++++++++++++--------------------
>  include/linux/usb/msm_hsusb.h     |    3 +++
>  4 files changed, 88 insertions(+), 20 deletions(-)



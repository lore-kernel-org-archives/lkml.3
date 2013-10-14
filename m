Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab3JNPfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:35:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3JNPfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:35:09 -0400
Date: Mon, 14 Oct 2013 08:33:56 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: USB regression in v3.12-rc4
Message-ID: <20131014153356.GA18373@kroah.com>
References: <20131012214618.GD29989@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131012214618.GD29989@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 12:46:18AM +0300, Aaro Koskinen wrote:
> Hi,
> 
> With v3.12-rc4 I can no longer connect to N800 (OMAP2) with USB
> (peripheral, g_ether).
> 
> According to git bisect this is caused by:
> 
> 9b0a1de3c85d99d881c86a29b3d52da7b9c7bd61 is the first bad commit
> commit 9b0a1de3c85d99d881c86a29b3d52da7b9c7bd61
> Author: Bin Liu <b-liu@ti.com>
> Date:   Tue Sep 17 15:33:35 2013 -0500
> 
>     usb: musb: gadget: fix otg active status flag
> 
>     In gadget mode, musb->is_active should be set only when connected to the
>     host. musb_g_reset() already takes care of it.
> 
>     Signed-off-by: Bin Liu <b-liu@ti.com>
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
> 
> Reverting that commit from v3.12-rc4 will fix the issue. Based on the
> commit log this is not fixing any real issue, so I wonder why was it
> included in -rc4 in the first place?

Hm, Felipe, should I just revert this patch for 3.12-final?

thanks,

greg k-h
